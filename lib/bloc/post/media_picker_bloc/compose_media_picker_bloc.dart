import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:exservice/bloc/post/composition_repository.dart';
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
  final CompositionRepository repository;

  List<AssetEntity> entities;
  AssetEntity focusedEntity;

  ComposeMediaPickerBloc(
    this.repository,
  ) : super(ComposeMediaPickerAwaitState()) {
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
        if (repository.entities.contains(event.entity)) {
          repository.entities.remove(event.entity);
          if (repository.entities.isNotEmpty) {
            focusedEntity = repository.entities.last;
          }
        } else {
          if (repository.entities.length >= 10) {
            emit(ComposeMediaPickerMaxLimitsErrorState());
            return;
          }
          repository.entities.add(event.entity);
          focusedEntity = event.entity;
        }
        emit(ComposeMediaPickerSelectMediaState());
      } else if (event is ComposeMediaPickerFocusEvent) {
        focusedEntity = event.entity;
        emit(ComposeMediaPickerSelectMediaState());
      } else if (event is ComposeMediaPickerDisplayModeEvent) {
        if (repository.mode == AspectRatioMode.tight)
          repository.mode = AspectRatioMode.square;
        else
          repository.mode = AspectRatioMode.tight;
        emit(ComposeMediaPickerDisplayModeState());
      }
    });
  }

  Future<Uint8List> get focusedThumbnail => getThumbnail(focusedEntity);

  Future<Uint8List> getThumbnail(AssetEntity entity) async {
    var thumb = repository.thumbnails[entity];
    if (thumb == null) {
      return repository.thumbnails[entity] =
          await entity.thumbnailDataWithSize(ThumbnailSize.square(400));
    } else {
      return thumb;
    }
  }
}
