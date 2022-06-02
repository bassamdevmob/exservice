import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:exservice/models/entity/ad_model.dart';
import 'package:exservice/models/entity/meta.dart';
import 'package:exservice/resources/repository/ad_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'ads_state.dart';

class AdsCubit extends Cubit<AdsState> {
  final refreshController = RefreshController();
  List<AdModel> models;
  Meta _meta;

  int mainIndex;
  int subIndex;

  bool get enablePullUp => _meta?.nextPageUrl != null;

  AdsCubit() : super(AdsAwaitState());

  @override
  Future<void> close() {
    refreshController.dispose();
    return super.close();
  }

  // void remove(int id) {
  //   for (int i = 0; i < models.length; i++) {
  //     if (models[i].id == id) {
  //       models.removeAt(i);
  //       break;
  //     }
  //   }
  //   emit(AdsAcceptState());
  // }

  Future<void> fetch() async {
    try {
      emit(AdsAwaitState());
      var response = await GetIt.I.get<AdRepository>().ads();
      _meta = response.meta;
      models = response.data;
      emit(AdsAcceptState());
      refreshController.refreshCompleted();
    } on DioError catch (ex) {
      emit(AdsErrorState(ex.error));
      refreshController.refreshFailed();
    }
  }

  Future<void> refresh() async {
    try {
      var response = await GetIt.I.get<AdRepository>().ads();
      _meta = response.meta;
      models = response.data;
      emit(AdsAcceptState());
      refreshController.refreshCompleted();
    } on DioError catch (ex) {
      emit(AdsLazyErrorState(ex.error));
      refreshController.refreshFailed();
    }
  }

  Future<void> loadMore() async {
    try {
      var response =
          await GetIt.I.get<AdRepository>().ads(nextUrl: _meta.nextPageUrl);
      _meta = response.meta;
      models.addAll(response.data);
      emit(AdsAcceptState());
      refreshController.loadComplete();
    } on DioError {
      refreshController.loadFailed();
    }
  }
}
