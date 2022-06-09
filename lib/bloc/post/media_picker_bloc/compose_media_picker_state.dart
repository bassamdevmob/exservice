part of 'compose_media_picker_bloc.dart';

@immutable
abstract class ComposeMediaPickerState {}

class ComposeMediaPickerAwaitState extends ComposeMediaPickerState {}

class ComposeMediaPickerAcceptState extends ComposeMediaPickerState {}

class ComposeMediaPickerDeniedState extends ComposeMediaPickerState {}

class ComposeMediaPickerMaxLimitsErrorState extends ComposeMediaPickerState {}

class ComposeMediaPickerSelectMediaState extends ComposeMediaPickerState {}

class ComposeMediaPickerDisplayModeState extends ComposeMediaPickerState {}
