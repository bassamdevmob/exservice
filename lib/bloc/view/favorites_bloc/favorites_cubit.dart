import 'package:bloc/bloc.dart';
import 'package:exservice/models/entity/ad_model.dart';
import 'package:exservice/resources/repository/ad_repository.dart';
import 'package:exservice/utils/constant.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  List<AdModel> models;
  int _offset = 0;
  final refreshController = RefreshController();

  FavoritesCubit() : super(FavoritesInitial());

  @override
  Future<void> close() {
    refreshController.dispose();
    return super.close();
  }

  Future<void> fetch() {
    emit(FavoritesAwaitState());
    return fetchFirst();
  }

  Future<void> fetchFirst() async {
    try {
      var response = await GetIt.I
          .get<AdRepository>()
          .bookmarkedAds();
      models = response.data;
      _offset = INITIAL_OFFSET;
      emit(FavoritesReceivedState());
    } catch (ex) {
      emit(FavoritesErrorState("$ex"));
    } finally {
      refreshController.refreshCompleted();
    }
  }

  Future<void> fetchNext() async {
    try {
      var response =
          await GetIt.I.get<AdRepository>().bookmarkedAds();
      _offset += 1;
      models.addAll(response.data);
      emit(FavoritesReceivedState());
    } catch (ex) {
      emit(FavoritesLazyErrorState("$ex"));
    } finally {
      refreshController.loadComplete();
    }
  }
}