part of 'compose_media_picker_bloc.dart';

@immutable
abstract class ComposeMediaPickerEvent {}

class ComposeMediaPickerFetchEvent extends ComposeMediaPickerEvent{}

class ComposeMediaPickerDisplayModeEvent extends ComposeMediaPickerEvent {}

class ComposeMediaPickerSelectEvent extends ComposeMediaPickerEvent {
  final AssetEntity entity;

  ComposeMediaPickerSelectEvent(this.entity);
}

class ComposeMediaPickerFocusEvent extends ComposeMediaPickerEvent {
  final AssetEntity entity;

  ComposeMediaPickerFocusEvent(this.entity);
}
