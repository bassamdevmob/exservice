part of 'publisher_cubit.dart';

@immutable
abstract class PublisherState {}

class PublisherChangeFormatState extends PublisherState {}

class PublisherAwaitState extends PublisherState {}

class PublisherReceivedState extends PublisherState {}

class PublisherErrorState extends PublisherState {
  final String message;

  PublisherErrorState(this.message);
}
