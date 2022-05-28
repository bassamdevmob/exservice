part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginCommitEvent extends LoginEvent {}

class LoginSecurePasswordEvent extends LoginEvent {}
