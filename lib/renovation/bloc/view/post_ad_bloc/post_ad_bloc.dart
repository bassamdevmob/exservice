import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:photo_manager/photo_manager.dart';

part 'post_ad_event.dart';

part 'post_ad_state.dart';

class AspectRatioSnapshot {
  final String id;
  final double value;

  const AspectRatioSnapshot(this.id, this.value);
}

const ratios = [
  AspectRatioSnapshot("TIGHT", 1.1),
  AspectRatioSnapshot("WIDE", 0.9),
];

class PostAdBloc extends Bloc<PostAdEvent, PostAdState> {
  final ScrollController nestedScrollController = ScrollController();
  List<AssetEntity> media;

  int index = 0;

  AspectRatioSnapshot get aspectRatio => ratios[index];
  List<AssetEntity> selectedEntities;

  PostAdBloc() : super(PostAdAwaitState());

  @override
  Future<void> close() {
    nestedScrollController.dispose();
    return super.close();
  }

  @override
  Stream<PostAdState> mapEventToState(
    PostAdEvent event,
  ) async* {
    if (event is FetchPostAdEvent) {
      var isGranted = await PhotoManager.requestPermission();
      if (isGranted) {
        var paths = await PhotoManager.getAssetPathList(
          type: RequestType.image,
          onlyAll: true,
        );
        media = await paths.first.assetList;
        selectedEntities.add(media.first);
        yield PostAdReceiveState();
      } else {
        // add(FetchPostAdEvent());
      }
    } else if (event is SelectMediaPostAdEvent) {
      if (selectedEntities.contains(event.entity)) {
        selectedEntities.remove(event.entity);
      } else {
        selectedEntities.add(event.entity);
      }
      nestedScrollController.animateTo(
        0,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
      yield PostAdSelectMediaState();
    } else if (event is ChangeDisplayModePostAdEvent) {
      index++;
      if (index >= ratios.length) index = 0;
      yield PostAdChangeDisplayModeState();
    }
  }
}
