part of 'edit_ad_bloc.dart';

@immutable
abstract class EditAdState {}

class EditAdInitial extends EditAdState {}

class EditAdValidationState extends EditAdState {}

class EditAdAwaitState extends EditAdState {}

class EditAdAcceptState extends EditAdState {}

class EditAdErrorState extends EditAdState {
  final dynamic error;

  EditAdErrorState(this.error);
}
