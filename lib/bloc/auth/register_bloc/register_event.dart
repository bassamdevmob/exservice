part of 'register_bloc.dart';

@immutable
abstract class RegisterEvent {}

class RegisterCommitEvent extends RegisterEvent {}

class RegisterSecurePasswordEvent extends RegisterEvent {}