import 'package:bloc/bloc.dart';
import 'package:exservice/bloc/post/composition_repository.dart';
import 'package:exservice/resources/repository/ad_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'upload_manager_event.dart';

part 'upload_manager_state.dart';

class UploadManagerBloc extends Bloc<UploadManagerEvent, UploadManagerState> {
  List<CompositionRepository> tasks = [];

  void upload(CompositionRepository task) {
    GetIt.I.get<AdRepository>().upload();
  }

  UploadManagerBloc() : super(UploadManagerInitial()) {
    on<UploadManagerInsertEvent>((event, emit) {
      tasks.add(event.repository);
      emit(UploadManagerUpdateState());
    });
  }
}
