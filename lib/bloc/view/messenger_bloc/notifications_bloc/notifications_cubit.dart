import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:exservice/models/entity/meta.dart';
import 'package:exservice/models/response/notifications_response.dart';
import 'package:exservice/resources/repository/user_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final refreshController = RefreshController();
  List<NotificationModel> models;
  Meta _meta;

  int mainIndex;
  int subIndex;

  bool get enablePullUp => _meta?.nextPageUrl != null;

  NotificationsCubit() : super(NotificationsAwaitState());

  @override
  Future<void> close() {
    refreshController.dispose();
    return super.close();
  }

  Future<void> fetch() async {
    try {
      emit(NotificationsAwaitState());
      var response = await GetIt.I.get<UserRepository>().notifications();
      _meta = response.meta;
      models = response.data;
      emit(NotificationsAcceptState());
      refreshController.refreshCompleted();
    } on DioError catch (ex) {
      emit(NotificationsErrorState(ex.error));
      refreshController.refreshFailed();
    }
  }

  Future<void> refresh() async {
    try {
      var response = await GetIt.I.get<UserRepository>().notifications();
      _meta = response.meta;
      models = response.data;
      emit(NotificationsAcceptState());
      refreshController.refreshCompleted();
    } on DioError catch (ex) {
      emit(NotificationsLazyErrorState(ex.error));
      refreshController.refreshFailed();
    }
  }

  Future<void> loadMore() async {
    try {
      var response = await GetIt.I.get<UserRepository>().notifications(
            nextUrl: _meta.nextPageUrl,
          );
      _meta = response.meta;
      models.addAll(response.data);
      emit(NotificationsAcceptState());
      refreshController.loadComplete();
    } on DioError {
      refreshController.loadFailed();
    }
  }
}
