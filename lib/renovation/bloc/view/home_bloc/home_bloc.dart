import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:exservice/renovation/models/common/ad_model.dart';
import 'package:exservice/renovation/models/common/category.dart';
import 'package:exservice/resources/api/ApiProviderDelegate.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  List<AdModel> adModels;
  List<Category> categories;
  int selectedId;

  HomeBloc() : super(HomeAwaitCategoriesState()) {
    on((event, emit) async {
      if (event is HomeFetchEvent) {
        try {
          emit(HomeAwaitCategoriesState());
          var responses = await Future.wait([
            GetIt.I.get<ApiProviderDelegate>().fetchCategories(),
            GetIt.I.get<ApiProviderDelegate>().fetchGetAdsList(selectedId)
          ]);
          categories = responses[0];
          adModels = responses[1];
          emit(HomeReceiveCategoriesState());
        } catch (e) {
          emit(HomeErrorCategoriesState("$e"));
        }
      } else if (event is HomeFetchAdsEvent) {
        try {
          emit(HomeAwaitAdsState());
          var response = await GetIt.I
              .get<ApiProviderDelegate>()
              .fetchGetAdsList(selectedId);
          adModels = response;
          emit(HomeReceiveAdsState());
        } catch (e) {
          emit(HomeErrorAdsState("$e"));
        }
      } else if (event is HomeSelectCategoryEvent) {
        selectedId = event.id;
        emit(HomeSelectCategoryState());
        add(HomeFetchAdsEvent());
      }
    });
  }
}
