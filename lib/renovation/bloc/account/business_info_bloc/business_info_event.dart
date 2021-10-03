part of 'business_info_bloc.dart';

@immutable
abstract class BusinessInfoEvent {}

class UpdateBusinessInfoEvent extends BusinessInfoEvent {}

class ResetBusinessInfoEvent extends BusinessInfoEvent {}
