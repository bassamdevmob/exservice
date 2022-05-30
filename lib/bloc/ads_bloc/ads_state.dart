part of 'ads_cubit.dart';

@immutable
abstract class AdsState {}

class AdsAwaitState extends AdsState {}

class AdsAcceptState extends AdsState {}

class AdsErrorState extends AdsState {
  final dynamic error;

  AdsErrorState(this.error);
}

class AdsLazyErrorState extends AdsState {
  final dynamic error;

  AdsLazyErrorState(this.error);
}
