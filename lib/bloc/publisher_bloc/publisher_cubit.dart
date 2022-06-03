import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:exservice/models/entity/ad_model.dart';
import 'package:exservice/models/entity/meta.dart';
import 'package:exservice/models/entity/user.dart';
import 'package:exservice/resources/repository/ad_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'publisher_state.dart';

class PublisherCubit extends Cubit<PublisherState> {
  final refreshController = RefreshController();
  final int id;
  User model;
  List<AdModel> ads = [];
  Meta _meta;

  bool get enablePullUp => _meta?.nextPageUrl != null;


  @override
  Future<void> close() {
    refreshController.dispose();
    return super.close();
  }

  PublisherCubit(this.id) : super(PublisherAwaitState());

  Future<void> fetch() async {
    try {
      emit(PublisherAwaitState());
      var response = await GetIt.I.get<AdRepository>().publisher(id);
      model = response.data;
      emit(PublisherAcceptState());
      loadMore();
    } on DioError catch (ex) {
      emit(PublisherErrorState(ex.error));
    }
  }

  Future<void> loadMore() async {
    try {
      var response =
      await GetIt.I.get<AdRepository>().ads(nextUrl: _meta?.nextPageUrl);
      _meta = response.meta;
      ads.addAll(response.data);
      emit(PublisherAdsAcceptState());
      refreshController.loadComplete();
    } on DioError {
      refreshController.loadFailed();
    }
  }
}
