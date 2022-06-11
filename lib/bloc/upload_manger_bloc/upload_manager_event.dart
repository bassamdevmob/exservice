part of 'upload_manager_bloc.dart';

@immutable
abstract class UploadManagerEvent {}

class UploadManagerInsertEvent implements UploadManagerEvent {
  final CompositionRepository model;

  UploadManagerInsertEvent(this.model);
}

class UploadManagerPopEvent implements UploadManagerEvent {}
