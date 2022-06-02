import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:exservice/models/entity/ad_model.dart';
import 'package:exservice/models/entity/meta.dart';
import 'package:exservice/resources/repository/user_repository.dart';
import 'package:exservice/utils/enums.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'account_ads_state.dart';

class AccountAdsCubit extends Cubit<AccountAdsState> {
  final refreshController = RefreshController();
  List<AdModel> models;
  Meta _meta;

  final Set<AdStatus> types = {AdStatus.active};

  bool get enablePullUp => _meta?.nextPageUrl != null;

  AccountAdsCubit() : super(AccountAdsAwaitState());

  @override
  Future<void> close() {
    refreshController.dispose();
    return super.close();
  }

  void select(AdStatus status) {
    if (types.contains(status)) {
      if (types.length == 1) return;
      types.remove(status);
    } else {
      types.add(status);
    }
    emit(AccountAdsChangeStatusState());
    fetch();
  }

  Future<void> fetch() async {
    try {
      emit(AccountAdsAwaitState());
      var response = await GetIt.I
          .get<UserRepository>()
          .ads(status: types.map((e) => e.name).toList());
      _meta = response.meta;
      models = response.data;
      emit(AccountAdsAcceptState());
      refreshController.refreshCompleted();
    } on DioError catch (ex) {
      emit(AccountAdsErrorState(ex.error));
      refreshController.refreshFailed();
    }
  }

  Future<void> refresh() async {
    try {
      var response = await GetIt.I
          .get<UserRepository>()
          .ads(status: types.map((e) => e.name).toList());
      _meta = response.meta;
      models = response.data;
      emit(AccountAdsAcceptState());
      refreshController.refreshCompleted();
    } on DioError catch (ex) {
      emit(AccountAdsLazyErrorState(ex.error));
      refreshController.refreshFailed();
    }
  }

  Future<void> loadMore() async {
    try {
      var response = await GetIt.I.get<UserRepository>().ads(
            nextUrl: _meta.nextPageUrl,
            status: types.map((e) => e.name).toList(),
          );
      _meta = response.meta;
      models.addAll(response.data);
      emit(AccountAdsAcceptState());
      refreshController.loadComplete();
    } on DioError {
      refreshController.loadFailed();
    }
  }
}
