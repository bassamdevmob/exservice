import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:exservice/models/entity/ad_model.dart';
import 'package:exservice/resources/repository/ad_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

part 'ad_details_event.dart';

part 'ad_details_state.dart';

enum DisplayMode {
  normal,
  review,
}

class AdDetailsBloc extends Bloc<AdDetailsEvent, AdDetailsState> {
  final int id;

  AdModel details;
  LatLng position;
  DisplayMode mode;

  AdDetailsBloc(
    this.id, {
    this.mode = DisplayMode.normal,
  }) : super(AdDetailsAwaitState()) {
    on((event, emit) async {
      if (event is AdDetailsFetchEvent) {
        try {
          emit(AdDetailsAwaitState());
          var response = await GetIt.I.get<AdRepository>().view(id);
          details = response.data;
          if (details.location != null)
            position = LatLng(
              double.parse(details.location.latitude),
              double.parse(details.location.longitude),
            );
          emit(AdDetailsAcceptState());
        } on DioError catch (e) {
          emit(AdDetailsErrorState(e));
        }
      } else if (event is AdDetailsBookmarkEvent) {
        try {
          emit(AdDetailsBookmarkAwaitState());
          var response = await GetIt.I
              .get<AdRepository>()
              .bookmark(details.id, !details.marked);
          details.marked = response.data;
          emit(AdDetailsBookmarkAcceptState());
        } on DioError catch (e) {
          emit(AdDetailsBookmarkErrorState(e));
        }
      }
    });
  }
}
