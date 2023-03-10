import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:exservice/bloc/profile_bloc/profile_bloc.dart';
import 'package:exservice/models/entity/ad_model.dart';
import 'package:exservice/resources/repository/ad_repository.dart';
import 'package:exservice/utils/enums.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:meta/meta.dart';

part 'ad_details_event.dart';

part 'ad_details_state.dart';

enum DisplayMode {
  normal,
  review,
}

class AdDetailsBloc extends Bloc<AdDetailsEvent, AdDetailsState> {
  final int id;
  final Locator locator;

  AdModel details;
  LatLng position;
  DisplayMode mode;

  bool get isOwned =>
      mode == DisplayMode.normal &&
      locator<ProfileBloc>().isAuthenticated &&
      locator<ProfileBloc>().model.id == details.owner.id;

  AdDetailsBloc(
    this.id, {
    @required this.locator,
  })  : this.mode = DisplayMode.normal,
        super(AdDetailsAwaitState()) {
    init();
  }

  AdDetailsBloc.review(this.details)
      : this.id = 0,
        this.locator = null,
        this.mode = DisplayMode.review,
        super(AdDetailsAcceptState()) {
    position = LatLng(
      double.parse(details.location.latitude),
      double.parse(details.location.longitude),
    );
    init();
  }

  void init() {
    on((event, emit) async {
      if (event is AdDetailsFetchEvent) {
        if (mode == DisplayMode.review) return;
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
        } on DioError catch (ex) {
          emit(AdDetailsErrorState(ex.error));
        }
      } else if (event is AdDetailsBookmarkEvent) {
        try {
          emit(AdDetailsBookmarkAwaitState());
          var response = await GetIt.I
              .get<AdRepository>()
              .bookmark(details.id, !details.marked);
          details.marked = response.data;
          emit(AdDetailsBookmarkAcceptState());
        } on DioError catch (ex) {
          emit(AdDetailsBookmarkErrorState(ex.error));
        }
      } else if (event is AdDetailsDeleteEvent) {
        try {
          emit(AdDetailsDeleteAwaitState());
          var response = await GetIt.I.get<AdRepository>().delete(details.id);
          emit(AdDetailsDeleteAcceptState(response.message));
        } on DioError catch (ex) {
          emit(AdDetailsDeleteErrorState(ex.error));
        }
      } else if (event is AdDetailsActivateEvent) {
        try {
          emit(AdDetailsStatusAwaitState());
          var response = await GetIt.I
              .get<AdRepository>()
              .changeAdStatus(details.id, AdStatus.active);
          details.status = AdStatus.active.name;
          emit(AdDetailsStatusAcceptState(AdStatus.active, response.message));
        } on DioError catch (ex) {
          emit(AdDetailsStatusErrorState(ex.error));
        }
      } else if (event is AdDetailsPauseEvent) {
        try {
          emit(AdDetailsStatusAwaitState());
          var response = await GetIt.I
              .get<AdRepository>()
              .changeAdStatus(details.id, AdStatus.paused);
          details.status = AdStatus.paused.name;
          emit(AdDetailsStatusAcceptState(AdStatus.paused, response.message));
        } on DioError catch (ex) {
          emit(AdDetailsStatusErrorState(ex.error));
        }
      } else if (event is AdDetailsUpdateEvent) {
        emit(AdDetailsAcceptState());
      }
    });
  }
}
