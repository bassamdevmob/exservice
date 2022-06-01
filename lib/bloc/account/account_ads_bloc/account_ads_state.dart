part of 'account_ads_cubit.dart';

@immutable
abstract class AccountAdsState {}

class AccountAdsAwaitState extends AccountAdsState {}

class AccountAdsAcceptState extends AccountAdsState {}

class AccountAdsErrorState extends AccountAdsState {
  final dynamic error;

  AccountAdsErrorState(this.error);
}

class AccountAdsLazyErrorState extends AccountAdsState {
  final dynamic error;

  AccountAdsLazyErrorState(this.error);
}
