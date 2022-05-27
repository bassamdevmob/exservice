part of 'ads_list_cubit.dart';

@immutable
abstract class AdsListState {}

class AdsListChangeFormatState extends AdsListState {}

class AdsListChangeCursorState extends AdsListState {}

class AdsListAwaitState extends AdsListState {}

class AdsListReceivedState extends AdsListState {}

class AdsListErrorState extends AdsListState {
  final String message;

  AdsListErrorState(this.message);
}

class AdsListLazyErrorState extends AdsListState {
  final String message;

  AdsListLazyErrorState(this.message);
}
