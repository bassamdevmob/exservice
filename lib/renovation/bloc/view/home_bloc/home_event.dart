part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class HomeFetchEvent extends HomeEvent {}

class HomeFetchAdsEvent extends HomeEvent {}

class HomeSelectCategoryEvent extends HomeEvent {
  final int id;

  HomeSelectCategoryEvent(this.id);
}
