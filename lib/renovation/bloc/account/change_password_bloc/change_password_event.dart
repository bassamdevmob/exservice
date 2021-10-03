part of 'change_password_bloc.dart';

@immutable
abstract class ChangePasswordEvent {}

// event for validation signup form
class ChangePasswordFormValidationEvent extends ChangePasswordEvent {}

// Show old password event  when click icon in text field
class ChangePasswordObscureOldPasswordEvent extends ChangePasswordEvent {}

// Show new password event  when click icon in text field
class ChangePasswordObscureNewPasswordEvent extends ChangePasswordEvent {}

// Show confirm password event  when click icon in text field
class ChangePasswordObscureConfirmPasswordEvent extends ChangePasswordEvent {}

class OnChangePasswordEvent extends ChangePasswordEvent {}
