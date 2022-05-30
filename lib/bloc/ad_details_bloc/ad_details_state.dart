part of 'ad_details_bloc.dart';

@immutable
abstract class AdDetailsState {}

class AdDetailsAwaitState extends AdDetailsState {}

class AdDetailsAcceptState extends AdDetailsState {}

class AdDetailsErrorState extends AdDetailsState {
  final dynamic error;

  AdDetailsErrorState(this.error);
}

class AdDetailsBookmarkAwaitState extends AdDetailsState {}

class AdDetailsBookmarkAcceptState extends AdDetailsState {}

class AdDetailsBookmarkErrorState extends AdDetailsState {
  final dynamic error;

  AdDetailsBookmarkErrorState(this.error);
}
