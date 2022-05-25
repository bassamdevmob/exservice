part of 'switch_business_bloc.dart';

@immutable
abstract class SwitchBusinessState {}

class SwitchBusinessInitial extends SwitchBusinessState {}

class SwitchBusinessValidationState extends SwitchBusinessState {}

class SwitchBusinessAwaitState extends SwitchBusinessState {}

class SwitchBusinessCommittedState extends SwitchBusinessState {}

class SwitchBusinessErrorState extends SwitchBusinessState {
  final String message;

  SwitchBusinessErrorState(this.message);
}
