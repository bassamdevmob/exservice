part of 'account_ads_cubit.dart';

@immutable
abstract class AccountAdsState {}

class AccountAdsAwaitState extends AccountAdsState {}

class AccountAdsReceivedState extends AccountAdsState {}

class AccountAdsErrorState extends AccountAdsState {
  final String message;

  AccountAdsErrorState(this.message);
}

class AccountAdsLazyErrorState extends AccountAdsState {
  final String message;

  AccountAdsLazyErrorState(this.message);
}
