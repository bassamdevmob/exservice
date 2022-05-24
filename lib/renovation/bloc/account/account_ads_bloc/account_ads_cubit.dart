import 'package:bloc/bloc.dart';
import 'package:exservice/renovation/models/entity/ad_model.dart';
import 'package:exservice/renovation/utils/constant.dart';
import 'package:exservice/renovation/utils/enums.dart';
import 'package:exservice/resources/api/ApiProviderDelegate.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'account_ads_state.dart';

class AccountAdsCubit extends Cubit<AccountAdsState> {
  List<AdModel> adModels;
  int _offset = 0;
  final refreshController = RefreshController();
  final AdStatus status;

  AccountAdsCubit(this.status) : super(AccountAdsAwaitState());

  Future<void> removeAd(AdModel ad) async {
    await GetIt.I.get<ApiProviderDelegate>().fetchDeleteAd(ad.id);
    adModels?.removeWhere((element) => element.id == ad.id);
    emit(AccountAdsReceivedState());
  }

  Future<void> pauseAd(AdModel ad) async {
    await GetIt.I
        .get<ApiProviderDelegate>()
        .fetchChangeAdStatus(ad.id, AdStatus.paused.id);
    ad.status = AdStatus.paused.id;
    emit(AccountAdsReceivedState());
  }

  Future<void> activateAd(AdModel ad) async {
    await GetIt.I
        .get<ApiProviderDelegate>()
        .fetchChangeAdStatus(ad.id, AdStatus.active.id);
    ad.status = AdStatus.active.id;
    emit(AccountAdsReceivedState());
  }

  @override
  Future<void> close() {
    refreshController.dispose();
    return super.close();
  }

  Future<void> fetch() {
    emit(AccountAdsAwaitState());
    return fetchFirst();
  }

  Future<void> fetchFirst() async {
    try {
      var response = await GetIt.I
          .get<ApiProviderDelegate>()
          .fetchGetUserAds(INITIAL_OFFSET, status.id);
      adModels = response;
      _offset = INITIAL_OFFSET;
      emit(AccountAdsReceivedState());
    } catch (ex) {
      emit(AccountAdsErrorState("$ex"));
    } finally {
      refreshController.refreshCompleted();
    }
  }

  Future<void> fetchNext() async {
    try {
      var response = await GetIt.I
          .get<ApiProviderDelegate>()
          .fetchGetUserAds(_offset + 1, status.id);
      _offset += 1;
      adModels.addAll(response);
      emit(AccountAdsReceivedState());
    } catch (ex) {
      emit(AccountAdsLazyErrorState("$ex"));
    } finally {
      refreshController.loadComplete();
    }
  }
}
