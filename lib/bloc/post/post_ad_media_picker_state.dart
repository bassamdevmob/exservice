part of 'post_ad_media_picker_bloc.dart';

@immutable
abstract class PostAdMediaPickerState {}

class PostAdMediaPickerAwaitState extends PostAdMediaPickerState {}
class PostAdMediaPickerAcceptState extends PostAdMediaPickerState {}
class PostAdMediaPickerDeniedState extends PostAdMediaPickerState {}
class PostAdMediaPickerMaxLimitsErrorState extends PostAdMediaPickerState {}
class PostAdMediaPickerSelectMediaState extends PostAdMediaPickerState {}
class PostAdMediaPickerDisplayModeState extends PostAdMediaPickerState {}
