part of 'edit_ad_bloc.dart';

@immutable
abstract class EditAdState {}

class EditAdInitial extends EditAdState {}
class EditAdValidationState extends EditAdState {}

class EditAdAwaitState extends EditAdState {}

class EditAdCommittedState extends EditAdState {}

class EditAdErrorState extends EditAdState {
  final String message;

  EditAdErrorState(this.message);
}
