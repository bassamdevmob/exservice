part of 'manage_email_bloc.dart';

@immutable
abstract class ManageEmailEvent {}

class ManageEmailCommitEvent extends ManageEmailEvent {}

class ManageEmailShowPasswordEvent extends ManageEmailEvent {}
