part of 'change_password_bloc.dart';

@immutable
abstract class ChangePasswordState {}

class ChangePasswordInitial extends ChangePasswordState {}

// state for validation change password form
class ChangePasswordFormValidationState extends ChangePasswordState {}

// Show old password state when isPassword attribute changed
class ChangePasswordShowOldPasswordState extends ChangePasswordState {}

// Show new password state when isPassword attribute changed
class ChangePasswordShowNewPasswordState extends ChangePasswordState {}

// Show confirm password state when isPassword attribute changed
class ChangePasswordShowConfirmPasswordState extends ChangePasswordState {}

class OnChangePasswordState extends ChangePasswordState {}

class ChangePasswordAwaitState extends ChangePasswordState {}

class ChangePasswordErrorState extends ChangePasswordState {
  final String message;

  ChangePasswordErrorState(this.message);
}
