part of 'compose_details_cubit.dart';

@immutable
abstract class ComposeDetailsState {}

class ComposeDetailsUpdateState extends ComposeDetailsState {}

class ComposeDetailsValidationState extends ComposeDetailsState {}

class ComposeDetailsAwaitState extends ComposeDetailsState {}

class ComposeDetailsAcceptState extends ComposeDetailsState {}

class ComposeDetailsErrorState extends ComposeDetailsState {
  final dynamic error;

  ComposeDetailsErrorState(this.error);
}
