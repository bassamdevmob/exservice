import 'package:bloc/bloc.dart';
import 'package:exservice/models/entity/ad_model.dart';
import 'package:exservice/resources/repository/ad_repository.dart';
import 'package:exservice/utils/constant.dart';
import 'package:exservice/utils/enums.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'account_ads_state.dart';

class AccountAdsCubit extends Cubit<AccountAdsState> {
  List<AdModel> models;
  int _offset = 0;
  final refreshController = RefreshController();
  final AdStatus status;

  AccountAdsCubit(this.status) : super(AccountAdsAwaitState());

  Future<void> removeAd(AdModel ad) async {
    var response = await GetIt.I.get<AdRepository>().delete(ad.id);
    models?.removeWhere((element) => element.id == ad.id);
    emit(AccountAdsReceivedState());
  }

  Future<void> pauseAd(AdModel ad) async {
    await GetIt.I
        .get<AdRepository>()
        .changeAdStatus(ad.id, AdStatus.paused);
    ad.status = AdStatus.paused.name;
    emit(AccountAdsReceivedState());
  }

  Future<void> activateAd(AdModel ad) async {
    await GetIt.I
        .get<AdRepository>()
        .changeAdStatus(ad.id, AdStatus.active);
    ad.status = AdStatus.active.name;
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
          .get<AdRepository>()
          .userAds(status);
      models = response.data;
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
          .get<AdRepository>()
          .userAds(status);
      _offset += 1;
      models.addAll(response.data);
      emit(AccountAdsReceivedState());
    } catch (ex) {
      emit(AccountAdsLazyErrorState("$ex"));
    } finally {
      refreshController.loadComplete();
    }
  }
}
