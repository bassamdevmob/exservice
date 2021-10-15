part of 'post_ad_bloc.dart';

@immutable
abstract class PostAdEvent {}

class FetchPostAdEvent extends PostAdEvent {}

class ChangeDisplayModePostAdEvent extends PostAdEvent {}

class SelectMediaPostAdEvent extends PostAdEvent {
  final AssetEntity entity;

  SelectMediaPostAdEvent(this.entity);
}

/// polar options
class PolarOptionPostAdEvent extends PostAdEvent {
  final bool value;

  PolarOptionPostAdEvent(this.value);
}

class ChangeGaragePostAdEvent extends PolarOptionPostAdEvent {
  ChangeGaragePostAdEvent(bool value) : super(value);
}

class ChangeTerracePostAdEvent extends PolarOptionPostAdEvent {
  ChangeTerracePostAdEvent(bool value) : super(value);
}

class ChangeGymPostAdEvent extends PolarOptionPostAdEvent {
  ChangeGymPostAdEvent(bool value) : super(value);
}
