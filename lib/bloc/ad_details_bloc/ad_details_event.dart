part of 'ad_details_bloc.dart';

@immutable
abstract class AdDetailsEvent {}

class AdDetailsFetchEvent extends AdDetailsEvent {}

class AdDetailsBookmarkEvent extends AdDetailsEvent {}
