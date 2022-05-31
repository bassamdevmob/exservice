part of 'manage_email_address_bloc.dart';

@immutable
abstract class ManageEmailAddressState {}

class ManageEmailAddressInitial extends ManageEmailAddressState {}

class ManageEmailAddressAwaitState extends ManageEmailAddressState {}

class ManageEmailAddressAcceptState extends ManageEmailAddressState {
  final String session;

  ManageEmailAddressAcceptState(this.session);
}

class ManageEmailAddressErrorState extends ManageEmailAddressState {
  final String message;

  ManageEmailAddressErrorState(this.message);
}

class ManageEmailAddressValidateState extends ManageEmailAddressState {}
