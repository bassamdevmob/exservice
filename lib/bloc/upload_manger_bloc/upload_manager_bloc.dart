import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:exservice/bloc/post/composition_repository.dart';
import 'package:exservice/models/entity/ad_model.dart';
import 'package:exservice/models/response/session_response.dart';
import 'package:exservice/resources/repository/ad_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:photo_manager/photo_manager.dart';

part 'upload_manager_event.dart';

part 'upload_manager_state.dart';

enum TaskStatus {
  uploading,
  completed,
  failed,
}

class UploadTask {
  final CompositionRepository model;
  Map<AssetEntity, double> imagesUploadProgress = {};
  TaskStatus status = TaskStatus.uploading;
  Object error;
  AdModel result;

  UploadTask(this.model);

  void failed(Object error) {
    this.error = error;
    status = TaskStatus.failed;
  }

  void completed(AdModel result) {
    this.result = result;
    status = TaskStatus.completed;
  }
}

class UploadManagerBloc extends Bloc<UploadManagerEvent, UploadManagerState> {
  final List<UploadTask> tasks = [];
  int _index = -1;

  UploadTask get _inProgressTask => tasks[_index];

  UploadManagerBloc() : super(UploadManagerInitial()) {
    on<UploadManagerInsertEvent>((event, emit) {
      tasks.add(UploadTask(event.model));
      if (_index < 0 || _inProgressTask.status != TaskStatus.uploading) {
        add(UploadManagerPopEvent());
      }
      emit(UploadManagerUpdateState());
    });
    on<UploadManagerPopEvent>((event, emit) async {
      try {
        _index++;
        var futures = <Future<SessionResponse>>[];
        for (var image in _inProgressTask.model.entities) {
          var file = await image.file;
          var future = GetIt.I.get<AdRepository>().uploadMedia(file.path,
              (count, total) {
            _inProgressTask.imagesUploadProgress[image] = count / total;
            emit(UploadManagerUpdateState());
          });
          futures.add(future);
        }

        var results = await Future.wait(futures);
        var sessions = results.map((e) => e.data.session).toList();
        var response = await GetIt.I
            .get<AdRepository>()
            .publish(sessions, _inProgressTask.model);
        _inProgressTask.completed(response.data);
        emit(UploadManagerUpdateState());
        if (_index + 1 < tasks.length) {
          add(UploadManagerPopEvent());
        }
      } on DioError catch (ex) {
        _inProgressTask.failed(ex.error);
        emit(UploadManagerUpdateState());
      }
    });
  }
}
