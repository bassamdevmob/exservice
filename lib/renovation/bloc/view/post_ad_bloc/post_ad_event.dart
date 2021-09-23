part of 'post_ad_bloc.dart';

@immutable
abstract class PostAdEvent {}

class FetchPostAdEvent extends PostAdEvent {}

class ChangeDisplayModePostAdEvent extends PostAdEvent {}

class SelectMediaPostAdEvent extends PostAdEvent {
  final AssetEntity entity;

  SelectMediaPostAdEvent(this.entity);
}
