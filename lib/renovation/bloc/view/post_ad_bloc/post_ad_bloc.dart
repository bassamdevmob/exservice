import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:exservice/renovation/utils/constant.dart';
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
  AspectRatioSnapshot("WIDE", ASPECT_RATIO),
  AspectRatioSnapshot("TIGHT", 1.1),
];

class PostAdBloc extends Bloc<PostAdEvent, PostAdState> {
  final titleController = TextEditingController();
  final detailsController = TextEditingController();
  final List<AssetEntity> selectedEntities = [];

  List<AssetEntity> media;
  AssetEntity placeholder;

  int aspectRatioIndex = 0;

  AspectRatioSnapshot get aspectRatio => ratios[aspectRatioIndex];

  List<AssetEntity> getSelectedMedias() => selectedEntities.isNotEmpty
      ? selectedEntities
      : <AssetEntity>[placeholder];

  PostAdBloc() : super(PostAdAwaitState());

  @override
  Future<void> close() {
    titleController.dispose();
    detailsController.dispose();
    return super.close();
  }

  final _thumbnails = <AssetEntity, Uint8List>{};

  Uint8List get thumbnail => _thumbnails[selectedEntities.first];

  Future<Uint8List> getThumbnail(AssetEntity entity) async {
    var thumb = _thumbnails[entity];
    if (thumb == null) {
      return _thumbnails[entity] = await entity.thumbDataWithSize(400, 400);
    } else {
      return thumb;
    }
  }

  @override
  Stream<PostAdState> mapEventToState(
    PostAdEvent event,
  ) async* {
    if (event is FetchPostAdEvent) {
      var isGranted = await PhotoManager.requestPermission();
      if (isGranted) {
        var paths = await PhotoManager.getAssetPathList(
          type: RequestType.common,
          onlyAll: true,
        );
        media = await paths.first.assetList;
        selectedEntities.add(media.first);
        yield PostAdAccessibleState();
      } else {
        // add(FetchPostAdEvent());
      }
    } else if (event is SelectMediaPostAdEvent) {
      if (selectedEntities.contains(event.entity)) {
        selectedEntities.remove(event.entity);
        placeholder = event.entity;
      } else {
        if (selectedEntities.length >= 10) {
          yield PostAdReachedMediaMaxLimitsErrorState();
          return;
        }
        selectedEntities.add(event.entity);
      }
      yield PostAdSelectMediaState();
    } else if (event is ChangeDisplayModePostAdEvent) {
      aspectRatioIndex++;
      if (aspectRatioIndex >= ratios.length) aspectRatioIndex = 0;
      yield PostAdChangeDisplayModeState();
    }
  }
}
