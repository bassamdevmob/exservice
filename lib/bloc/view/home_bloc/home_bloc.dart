import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:exservice/models/entity/ad_model.dart';
import 'package:exservice/models/entity/category.dart';
import 'package:exservice/models/response/ads_response.dart';
import 'package:exservice/models/response/categories_response.dart';
import 'package:exservice/resources/repository/ad_repository.dart';
import 'package:exservice/resources/repository/config_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  List<AdModel> models;
  List<Category> categories;
  int categoryId;

  HomeBloc() : super(HomeAwaitCategoriesState()) {
    on((event, emit) async {
      if (event is HomeFetchEvent) {
        try {
          emit(HomeAwaitCategoriesState());
          var responses = await Future.wait([
            GetIt.I.get<ConfigRepository>().categories(),
            GetIt.I.get<AdRepository>().ads(categoryId: categoryId)
          ]);
          categories = (responses[0] as CategoriesResponse).data;
          models = (responses[1] as AdsResponse).data;
          emit(HomeReceiveCategoriesState());
        } catch (e) {
          emit(HomeErrorCategoriesState("$e"));
        }
      } else if (event is HomeFetchAdsEvent) {
        try {
          emit(HomeAwaitAdsState());
          var response =
              await GetIt.I.get<AdRepository>().ads(categoryId: categoryId);
          models = response.data;
          emit(HomeReceiveAdsState());
        } catch (e) {
          emit(HomeErrorAdsState("$e"));
        }
      } else if (event is HomeSelectCategoryEvent) {
        categoryId = event.id;
        emit(HomeSelectCategoryState());
        add(HomeFetchAdsEvent());
      }
    });
  }
}
