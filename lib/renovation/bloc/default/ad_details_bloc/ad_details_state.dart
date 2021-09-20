part of 'ad_details_bloc.dart';

@immutable
abstract class AdDetailsState {}

class AdDetailsAwaitState extends AdDetailsState {}

class AdDetailsReceivedState extends AdDetailsState {}

class AdDetailsErrorState extends AdDetailsState {
  final String message;

  AdDetailsErrorState(this.message);
}
