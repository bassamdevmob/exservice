part of 'ad_details_bloc.dart';

@immutable
abstract class AdDetailsEvent {}

class AdDetailsUpdateEvent extends AdDetailsEvent {}

class AdDetailsPauseEvent extends AdDetailsEvent {}

class AdDetailsActivateEvent extends AdDetailsEvent {}

class AdDetailsDeleteEvent extends AdDetailsEvent {}

class AdDetailsFetchEvent extends AdDetailsEvent {}

class AdDetailsBookmarkEvent extends AdDetailsEvent {}
