
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:exservice/models/entity/ad_model.dart';
import 'package:exservice/models/entity/category.dart';
import 'package:exservice/resources/repository/ad_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  List<AdModel> ads;
  List<Category> categories;
  int categoryId;

  HomeBloc() : super(HomeAwaitState()) {
    on((event, emit) async {
      if (event is HomeFetchEvent) {
        try {
          emit(HomeAwaitState());
          var response = await GetIt.I.get<AdRepository>().home();
          ads = response.data.ads;
          categories = response.data.categories;
          emit(HomeAcceptState());
        } on DioError catch (ex) {
          emit(HomeErrorState(ex.error));
        }
      } else if (event is HomeFetchAdsEvent) {
        try {
          emit(HomeAdsAwaitState());
          var response =
              await GetIt.I.get<AdRepository>().ads(categoryId: categoryId);
          ads = response.data;
          emit(HomeAdsAcceptState());
        } on DioError catch (ex) {
          emit(HomeAdsErrorState(ex.error));
        }
      } else if (event is HomeSelectCategoryEvent) {
        categoryId = event.id;
        emit(HomeSelectCategoryState());
        add(HomeFetchAdsEvent());
      }
    });
  }
}
