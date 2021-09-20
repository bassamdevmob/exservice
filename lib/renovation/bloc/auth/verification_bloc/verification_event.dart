part of 'verification_bloc.dart';

@immutable
abstract class VerificationEvent {}

class VerificationValidateEvent extends VerificationEvent {}

class VerificationCommitEvent extends VerificationEvent {}

class VerificationResendPinEvent extends VerificationEvent {}
