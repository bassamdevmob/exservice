part of 'publisher_cubit.dart';

@immutable
abstract class PublisherState {}

class PublisherAwaitState extends PublisherState {}

class PublisherAcceptState extends PublisherState {}

class PublisherErrorState extends PublisherState {
  final dynamic error;

  PublisherErrorState(this.error);
}

class PublisherAdsAcceptState extends PublisherState {}

