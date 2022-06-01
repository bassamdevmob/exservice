import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:exservice/models/entity/ad_model.dart';
import 'package:exservice/models/entity/meta.dart';
import 'package:exservice/resources/repository/ad_repository.dart';
import 'package:exservice/utils/enums.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'account_ads_state.dart';

class AccountAdsCubit extends Cubit<AccountAdsState> {
  final refreshController = RefreshController();
  List<AdModel> models;
  Meta _meta;

  final AdStatus status;

  bool get enablePullUp => _meta?.nextPageUrl != null;

  AccountAdsCubit(this.status) : super(AccountAdsAwaitState());

  @override
  Future<void> close() {
    refreshController.dispose();
    return super.close();
  }

  Future<void> removeAd(AdModel ad) async {
    var response = await GetIt.I.get<AdRepository>().delete(ad.id);
    models?.removeWhere((element) => element.id == ad.id);
    emit(AccountAdsAcceptState());
  }

  Future<void> pauseAd(AdModel ad) async {
    await GetIt.I
        .get<AdRepository>()
        .changeAdStatus(ad.id, AdStatus.paused);
    ad.status = AdStatus.paused.name;
    emit(AccountAdsAcceptState());
  }

  Future<void> activateAd(AdModel ad) async {
    await GetIt.I
        .get<AdRepository>()
        .changeAdStatus(ad.id, AdStatus.active);
    ad.status = AdStatus.active.name;
    emit(AccountAdsAcceptState());
  }

  Future<void> fetch() async {
    try {
      emit(AccountAdsAwaitState());
      var response = await GetIt.I.get<AdRepository>().bookmarkedAds();
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
      var response = await GetIt.I.get<AdRepository>().bookmarkedAds();
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
      var response = await GetIt.I
          .get<AdRepository>()
          .bookmarkedAds(nextUrl: _meta.nextPageUrl);
      _meta = response.meta;
      models.addAll(response.data);
      emit(AccountAdsAcceptState());
      refreshController.loadComplete();
    } on DioError {
      refreshController.loadFailed();
    }
  }
}
