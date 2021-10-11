part of 'manage_email_address_bloc.dart';

@immutable
abstract class ManageEmailAddressEvent {}

class ManageEmailAddressValidateEvent extends ManageEmailAddressEvent {}

class ManageEmailAddressCommitEvent extends ManageEmailAddressEvent {}

class ManageEmailAddressShowPasswordEvent extends ManageEmailAddressEvent {}
