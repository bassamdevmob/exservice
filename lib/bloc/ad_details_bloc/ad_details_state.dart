part of 'ad_details_bloc.dart';

@immutable
abstract class AdDetailsState {}

class AdDetailsAwaitState extends AdDetailsState {}

class AdDetailsAcceptState extends AdDetailsState {}

class AdDetailsErrorState extends AdDetailsState {
  final dynamic error;

  AdDetailsErrorState(this.error);
}

///bookmark

class AdDetailsBookmarkAwaitState extends AdDetailsState {}

class AdDetailsBookmarkAcceptState extends AdDetailsState {}

class AdDetailsBookmarkErrorState extends AdDetailsState {
  final dynamic error;

  AdDetailsBookmarkErrorState(this.error);
}

///delete

class AdDetailsDeleteAwaitState extends AdDetailsState {}

class AdDetailsDeleteAcceptState extends AdDetailsState {
  final String message;

  AdDetailsDeleteAcceptState(this.message);
}

class AdDetailsDeleteErrorState extends AdDetailsState {
  final dynamic error;

  AdDetailsDeleteErrorState(this.error);
}

///status

class AdDetailsStatusAwaitState extends AdDetailsState {}

class AdDetailsStatusAcceptState extends AdDetailsState {
  final String message;

  AdDetailsStatusAcceptState(this.message);
}

class AdDetailsStatusErrorState extends AdDetailsState {
  final dynamic error;

  AdDetailsStatusErrorState(this.error);
}
