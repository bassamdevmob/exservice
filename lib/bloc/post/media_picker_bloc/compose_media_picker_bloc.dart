import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:photo_manager/photo_manager.dart';

part 'compose_media_picker_event.dart';

part 'compose_media_picker_state.dart';

class AspectRatioMode {
  final String id;
  final double value;

  const AspectRatioMode(this.id, this.value);

  static const tight = AspectRatioMode("TIGHT", 0.7);
  static const square = AspectRatioMode("SQUARE", 1);
}

class ComposeMediaPickerBloc
    extends Bloc<ComposeMediaPickerEvent, ComposeMediaPickerState> {
  List<AssetEntity> entities;
  AspectRatioMode mode = AspectRatioMode.square;
  AssetEntity focusedEntity;

  final List<AssetEntity> selectedEntities = [];

  ComposeMediaPickerBloc() : super(ComposeMediaPickerAwaitState()) {
    on<ComposeMediaPickerEvent>((event, emit) async {
      if (event is ComposeMediaPickerFetchEvent) {
        emit(ComposeMediaPickerAwaitState());
        var result = await PhotoManager.requestPermissionExtend();
        if (result.isAuth) {
          var paths = await PhotoManager.getAssetPathList(
            type: RequestType.image,
            onlyAll: true,
          );
          entities = await paths.first.getAssetListPaged(page: 0, size: 80);
          focusedEntity = entities.first;
          emit(ComposeMediaPickerAcceptState());
        } else {
          emit(ComposeMediaPickerDeniedState());
        }
      } else if (event is ComposeMediaPickerSelectEvent) {
        if (selectedEntities.contains(event.entity)) {
          selectedEntities.remove(event.entity);
          if (selectedEntities.isNotEmpty) {
            focusedEntity = selectedEntities.last;
          }
        } else {
          if (selectedEntities.length >= 10) {
            emit(ComposeMediaPickerMaxLimitsErrorState());
            return;
          }
          selectedEntities.add(event.entity);
          focusedEntity = event.entity;
        }
        emit(ComposeMediaPickerSelectMediaState());
      } else if (event is ComposeMediaPickerFocusEvent) {
        focusedEntity = event.entity;
        emit(ComposeMediaPickerSelectMediaState());
      } else if (event is ComposeMediaPickerDisplayModeEvent) {
        if (mode == AspectRatioMode.tight)
          mode = AspectRatioMode.square;
        else
          mode = AspectRatioMode.tight;
        emit(ComposeMediaPickerDisplayModeState());
      }
    });
  }

  final _thumbnails = <AssetEntity, Uint8List>{};

  Uint8List get thumbnail => _thumbnails[selectedEntities.first];

  Future<Uint8List> get focusedThumbnail => getThumbnail(focusedEntity);

  Future<Uint8List> getThumbnail(AssetEntity entity) async {
    var thumb = _thumbnails[entity];
    if (thumb == null) {
      return _thumbnails[entity] =
          await entity.thumbnailDataWithSize(ThumbnailSize.square(400));
    } else {
      return thumb;
    }
  }
}
