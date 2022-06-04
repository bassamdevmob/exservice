part of 'post_ad_media_picker_bloc.dart';

@immutable
abstract class PostAdMediaPickerEvent {}

class PostAdMediaPickerFetchEvent extends PostAdMediaPickerEvent{}

class PostAdMediaPickerDisplayModeEvent extends PostAdMediaPickerEvent {}

class PostAdMediaPickerSelectEvent extends PostAdMediaPickerEvent {
  final AssetEntity entity;

  PostAdMediaPickerSelectEvent(this.entity);
}

class PostAdMediaPickerFocusEvent extends PostAdMediaPickerEvent {
  final AssetEntity entity;

  PostAdMediaPickerFocusEvent(this.entity);
}
