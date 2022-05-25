part of 'post_ad_bloc.dart';

@immutable
abstract class PostAdState {}

class PostAdAwaitState extends PostAdState {}

class PostAdAccessibleState extends PostAdState {}

class PostAdErrorState extends PostAdState {}

class PostAdReachedMediaMaxLimitsErrorState extends PostAdState {}

class PostAdSelectMediaState extends PostAdState {}

class PostAdChangeDisplayModeState extends PostAdState {}

/// details
class PostAdChangeOptionState extends PostAdState {}
