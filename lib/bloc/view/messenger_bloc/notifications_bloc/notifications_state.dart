part of 'notifications_cubit.dart';

@immutable
abstract class NotificationsState {}

class NotificationsAwaitState extends NotificationsState {}

class NotificationsAcceptState extends NotificationsState {}

class NotificationsErrorState extends NotificationsState {
  final dynamic error;

  NotificationsErrorState(this.error);
}

class NotificationsLazyErrorState extends NotificationsState {
  final dynamic error;

  NotificationsLazyErrorState(this.error);
}
