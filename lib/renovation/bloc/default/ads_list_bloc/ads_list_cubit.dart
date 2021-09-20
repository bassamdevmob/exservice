import 'package:bloc/bloc.dart';
import 'package:exservice/helper/Enums.dart';
import 'package:exservice/models/common/AdModel.dart';
import 'package:exservice/renovation/utils/constant.dart';
import 'package:exservice/resources/api/ApiProviderDelegate.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'ads_list_state.dart';

class AdsFilterSettings {
  AdsFilterSettings({
    townId,
    ownerId,
    status,
    option,
    type,
    furniture,
    rooms,
    balcony,
    bath,
    terrace,
    fromPrice,
    toPrice,
    garage,
    fromSize,
    toSize,
  });
}

class AdsListCubit extends Cubit<AdsListState> {
  List<AdModel> adModels;
  int _offset = 0;
  final refreshController = RefreshController();
  final scrollController = ScrollController();

  DisplayFormat format = DisplayFormat.list;
  int mainIndex;
  int subIndex;

  AdsListCubit() : super(AdsListAwaitState());

  @override
  Future<void> close() {
    refreshController.dispose();
    scrollController.dispose();
    return super.close();
  }

  void changeFormat(DisplayFormat format) {
    if (this.format == format) return;
    this.format = format;
    if (scrollController.hasClients) scrollController.jumpTo(0);
    emit(AdsListChangeFormatState());
  }

  Future<void> fetch() {
    emit(AdsListAwaitState());
    return fetchFirst();
  }

  Future<void> fetchFirst() async {
    try {
      var response = await GetIt.I
          .get<ApiProviderDelegate>()
          .fetchGetAdsList(INITIAL_OFFSET);
      adModels = response;
      _offset = INITIAL_OFFSET;
      emit(AdsListReceivedState());
    } catch (ex) {
      emit(AdsListErrorState("$ex"));
    } finally {
      refreshController.refreshCompleted();
    }
  }

  Future<void> fetchNext() async {
    try {
      var response =
          await GetIt.I.get<ApiProviderDelegate>().fetchGetAdsList(_offset + 1);
      _offset += 1;
      adModels.addAll(response);
      emit(AdsListReceivedState());
    } catch (ex) {
      emit(AdsListLazyErrorState("$ex"));
    } finally {
      refreshController.loadComplete();
    }
  }
}
