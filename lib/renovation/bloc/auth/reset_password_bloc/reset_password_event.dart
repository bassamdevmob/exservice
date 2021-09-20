part of 'reset_password_bloc.dart';

@immutable
abstract class ResetPasswordEvent {}

class ResetPasswordValidateEvent extends ResetPasswordEvent {}

class ResetPasswordCommitEvent extends ResetPasswordEvent {}

class ResetPasswordSecurePasswordEvent extends ResetPasswordEvent {}
