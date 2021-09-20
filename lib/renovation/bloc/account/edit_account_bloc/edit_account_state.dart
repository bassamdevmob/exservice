part of 'edit_account_cubit.dart';

@immutable
abstract class EditAccountState {}

class EditAccountInitial extends EditAccountState {}

class EditAccountAwaitState extends EditAccountState {}

class EditAccountCommittedState extends EditAccountState {}

class EditAccountErrorState extends EditAccountState {
  final String message;

  EditAccountErrorState(this.message);
}
