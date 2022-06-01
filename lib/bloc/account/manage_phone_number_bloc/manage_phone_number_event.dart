part of 'manage_phone_number_bloc.dart';

@immutable
abstract class ManagePhoneNumberEvent {}

class ManagePhoneNumberCommitEvent extends ManagePhoneNumberEvent {}

class ManagePhoneNumberShowPasswordEvent extends ManagePhoneNumberEvent {}
