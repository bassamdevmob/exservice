part of 'account_bloc.dart';

@immutable
abstract class AccountEvent {}

class AccountFetchEvent extends AccountEvent {}

class AccountRefreshEvent extends AccountEvent {}

class AccountChangeTabEvent extends AccountEvent {
  final AccountTab tab;

  AccountChangeTabEvent(this.tab);
}

class AccountUploadVideoEvent extends AccountEvent {
  final String path;

  AccountUploadVideoEvent(this.path);
}

class AccountChangeProfileImageEvent extends AccountEvent {
  final String path;

  AccountChangeProfileImageEvent(this.path);
}
