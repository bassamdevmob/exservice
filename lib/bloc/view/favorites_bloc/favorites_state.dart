part of 'favorites_cubit.dart';

@immutable
abstract class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class FavoritesAwaitState extends FavoritesState {}

class FavoritesReceivedState extends FavoritesState {}

class FavoritesErrorState extends FavoritesState {
  final String message;

  FavoritesErrorState(this.message);
}

class FavoritesLazyErrorState extends FavoritesState {
  final String message;

  FavoritesLazyErrorState(this.message);
}
