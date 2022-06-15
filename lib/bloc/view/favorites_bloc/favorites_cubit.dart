import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:exservice/models/entity/ad_model.dart';
import 'package:exservice/models/entity/meta.dart';
import 'package:exservice/resources/repository/ad_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final controller = RefreshController();
  List<AdModel> models;
  Meta _meta;

  bool get enablePullUp => _meta?.nextPageUrl != null;

  FavoritesCubit() : super(FavoritesAwaitState());

  @override
  Future<void> close() {
    controller.dispose();
    return super.close();
  }

  Future<void> fetch() async {
    try {
      emit(FavoritesAwaitState());
      var response = await GetIt.I.get<AdRepository>().bookmarkedAds();
      _meta = response.meta;
      models = response.data;
      emit(FavoritesAcceptState());
      controller.refreshCompleted();
    } on DioError catch (ex) {
      emit(FavoritesErrorState(ex.error));
      controller.refreshFailed();
    }
  }

  Future<void> refresh() async {
    try {
      var response = await GetIt.I.get<AdRepository>().bookmarkedAds();
      _meta = response.meta;
      models = response.data;
      emit(FavoritesAcceptState());
      controller.refreshCompleted();
    } on DioError catch (ex) {
      emit(FavoritesLazyErrorState(ex.error));
      controller.refreshFailed();
    }
  }

  Future<void> loadMore() async {
    try {
      var response = await GetIt.I
          .get<AdRepository>()
          .bookmarkedAds(nextUrl: _meta.nextPageUrl);
      _meta = response.meta;
      models.addAll(response.data);
      emit(FavoritesAcceptState());
      controller.loadComplete();
    } on DioError {
      controller.loadFailed();
    }
  }
}
