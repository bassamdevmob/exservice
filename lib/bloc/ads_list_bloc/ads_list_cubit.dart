import 'package:bloc/bloc.dart';
import 'package:exservice/models/entity/ad_model.dart';
import 'package:exservice/resources/repository/ad_repository.dart';
import 'package:exservice/utils/constant.dart';
import 'package:exservice/utils/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'ads_list_state.dart';

class AdsListCubit extends Cubit<AdsListState> {
  List<AdModel> models;
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
      var response = await GetIt.I.get<AdRepository>().ads();
      models = response.data;
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
      var response = await GetIt.I.get<AdRepository>().ads(); //todo next
      _offset += 1;
      models.addAll(response.data);
      emit(AdsListReceivedState());
    } catch (ex) {
      emit(AdsListLazyErrorState("$ex"));
    } finally {
      refreshController.loadComplete();
    }
  }
}
