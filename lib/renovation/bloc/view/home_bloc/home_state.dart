part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

abstract class HomeAwaitState extends HomeState {}

abstract class HomeReceiveState extends HomeState {}

class HomeSelectCategoryState extends HomeState {}

/// categories

class HomeAwaitCategoriesState extends HomeAwaitState {}

class HomeReceiveCategoriesState extends HomeReceiveState {}

class HomeErrorCategoriesState extends HomeState {
  final String message;

  HomeErrorCategoriesState(this.message);
}

/// ads
class HomeAwaitAdsState extends HomeAwaitState {}

class HomeReceiveAdsState extends HomeReceiveState {}

class HomeErrorAdsState extends HomeState {
  final String message;

  HomeErrorAdsState(this.message);
}
