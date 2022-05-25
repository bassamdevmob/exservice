part of 'business_info_bloc.dart';

@immutable
abstract class BusinessInfoState {}

class BusinessInfoInitial extends BusinessInfoState {}

class BusinessInfoAwaitState extends BusinessInfoState {}

class BusinessInfoValidateState extends BusinessInfoState {}

class BusinessInfoCommittedState extends BusinessInfoState {}

class BusinessInfoResetState extends BusinessInfoState {}

class BusinessInfoErrorState extends BusinessInfoState {
  final String message;

  BusinessInfoErrorState(this.message);
}
