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
abstract class PolarOptionPostAdEvent extends PostAdEvent {
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

/// polar options
abstract class SingleOptionPostAdEvent extends PostAdEvent {
  final OptionModel value;

  SingleOptionPostAdEvent(this.value);
}

class ChangeTypePostAdEvent extends SingleOptionPostAdEvent {
  ChangeTypePostAdEvent(OptionModel value) : super(value);
}

class ChangeRoomPostAdEvent extends SingleOptionPostAdEvent {
  ChangeRoomPostAdEvent(OptionModel value) : super(value);
}

class ChangeBathPostAdEvent extends SingleOptionPostAdEvent {
  ChangeBathPostAdEvent(OptionModel value) : super(value);
}

class ChangeFurniturePostAdEvent extends SingleOptionPostAdEvent {
  ChangeFurniturePostAdEvent(OptionModel value) : super(value);
}

class ChangeSecurityPostAdEvent extends SingleOptionPostAdEvent {
  ChangeSecurityPostAdEvent(OptionModel value) : super(value);
}

class ChangeBalconyPostAdEvent extends SingleOptionPostAdEvent {
  ChangeBalconyPostAdEvent(OptionModel value) : super(value);
}
