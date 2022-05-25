part of 'forgot_password_bloc.dart';

@immutable
abstract class ForgotPasswordEvent {}

class ForgotPasswordValidateEvent extends ForgotPasswordEvent {}

class ForgotPasswordCommitEvent extends ForgotPasswordEvent {}
