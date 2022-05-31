part of 'change_password_bloc.dart';

@immutable
abstract class ChangePasswordState {}

class ChangePasswordInitial extends ChangePasswordState {}

class ChangePasswordShowOldPasswordState extends ChangePasswordState {}

class ChangePasswordShowNewPasswordState extends ChangePasswordState {}

class ChangePasswordShowConfirmPasswordState extends ChangePasswordState {}

class ChangePasswordValidationState extends ChangePasswordState {}

class ChangePasswordAwaitState extends ChangePasswordState {}

class ChangePasswordAcceptState extends ChangePasswordState {}

class ChangePasswordErrorState extends ChangePasswordState {
  final dynamic error;

  ChangePasswordErrorState(this.error);
}
