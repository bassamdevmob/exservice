part of 'change_password_bloc.dart';

@immutable
abstract class ChangePasswordEvent {}

class ChangePasswordObscureOldPasswordEvent extends ChangePasswordEvent {}

class ChangePasswordObscureNewPasswordEvent extends ChangePasswordEvent {}

class ChangePasswordObscureConfirmPasswordEvent extends ChangePasswordEvent {}

class ChangePasswordCommitEvent extends ChangePasswordEvent {}
