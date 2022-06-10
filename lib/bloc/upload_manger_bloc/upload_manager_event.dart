part of 'upload_manager_bloc.dart';

@immutable
abstract class UploadManagerEvent {}

class UploadManagerInsertEvent implements UploadManagerEvent {
  final CompositionRepository repository;

  UploadManagerInsertEvent(this.repository);
}
