part of 'post_ad_bloc.dart';

@immutable
abstract class PostAdState {}

class PostAdAwaitState extends PostAdState {}

class PostAdReceiveState extends PostAdState {}

class PostAdErrorState extends PostAdState {}

class PostAdReachedMediaMaxLimitsErrorState extends PostAdState {}

class PostAdSelectMediaState extends PostAdState {}

class PostAdChangeDisplayModeState extends PostAdState {}
