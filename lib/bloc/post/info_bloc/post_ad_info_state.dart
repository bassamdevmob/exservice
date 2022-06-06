part of 'post_ad_info_cubit.dart';

@immutable
abstract class PostAdInfoState {}

class PostAdInfoUpdateState extends PostAdInfoState {}

class PostAdInfoValidationState extends PostAdInfoState {}

class PostAdInfoAwaitState extends PostAdInfoState {}

class PostAdInfoAcceptState extends PostAdInfoState {}

class PostAdInfoErrorState extends PostAdInfoState {
  final dynamic error;

  PostAdInfoErrorState(this.error);
}
