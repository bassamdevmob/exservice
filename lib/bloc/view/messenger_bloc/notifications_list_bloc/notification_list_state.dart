part of 'notification_list_bloc.dart';

@immutable
abstract class NotificationListState {}

class NotificationListAwaitState extends NotificationListState {}

class NotificationListReceivedState extends NotificationListState {}

class NotificationListErrorState extends NotificationListState {
  final String message;

  NotificationListErrorState(this.message);
}
