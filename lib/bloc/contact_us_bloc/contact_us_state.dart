part of 'contact_us_bloc.dart';

@immutable
abstract class ContactUsState {}

class ContactUsInitial extends ContactUsState {}

class ContactUsAwaitState extends ContactUsState {}

class ContactUsAcceptState extends ContactUsState {}

class ContactUsErrorState extends ContactUsState {
  final String message;

  ContactUsErrorState(this.message);
}

class ContactUsValidationState extends ContactUsState {}
