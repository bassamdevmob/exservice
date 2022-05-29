part of 'favorites_cubit.dart';

@immutable
abstract class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class FavoritesAwaitState extends FavoritesState {}

class FavoritesAcceptState extends FavoritesState {}

class FavoritesErrorState extends FavoritesState {
  final dynamic error;

  FavoritesErrorState(this.error);
}

class FavoritesLazyErrorState extends FavoritesState {
  final dynamic error;

  FavoritesLazyErrorState(this.error);
}
