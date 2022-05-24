import 'package:bloc/bloc.dart';
import 'package:exservice/renovation/models/entity/ad_model.dart';
import 'package:exservice/resources/api/ApiProviderDelegate.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

part 'ad_details_event.dart';

part 'ad_details_state.dart';

class AdDetailsBloc extends Bloc<AdDetailsEvent, AdDetailsState> {
  final int id;

  AdDetailsBloc(this.id) : super(AdDetailsAwaitState()) {
    on((event, emit) async {
      if (event is FetchAdDetailsEvent) {
        try {
          emit(AdDetailsAwaitState());
          details =
              await GetIt.I.get<ApiProviderDelegate>().fetchGetAdDetails(id);
          if (details.latitude != null && details.longitude != null)
            position = LatLng(details.latitude, details.longitude);
          emit(AdDetailsReceivedState());
        } catch (e) {
          emit(AdDetailsErrorState("$e"));
        }
      } else if (event is SwitchSaveAdDetailsEvent) {
        details.saved = !details.saved;
        emit(UpdateSaveAdDetailsState());
        GetIt.I
            .get<ApiProviderDelegate>()
            .fetchSaveAd(details.id, details.saved);
      }
    });
  }

  AdModel details;
  LatLng position;
}
