part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeSelectCategoryState extends HomeState {}

/// categories

class HomeAwaitState extends HomeState {}

class HomeAcceptState extends HomeState {}

class HomeErrorState extends HomeState {
  final dynamic error;

  HomeErrorState(this.error);
}

/// ads
class HomeAdsAwaitState extends HomeState {}

class HomeAdsAcceptState extends HomeState {}

class HomeAdsErrorState extends HomeState {
  final dynamic error;

  HomeAdsErrorState(this.error);
}
