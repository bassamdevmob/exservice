import 'package:bloc/bloc.dart';
import 'package:exservice/models/entity/ad_model.dart';
import 'package:exservice/resources/repository/ad_repository.dart';
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
          var response = await GetIt.I.get<AdRepository>().view(id);
          details = response.data;
          if (details.location != null)
            position = LatLng(double.parse(details.location.latitude),
                double.parse(details.location.longitude));
          emit(AdDetailsReceivedState());
        } catch (e) {
          emit(AdDetailsErrorState("$e"));
        }
      } else if (event is SwitchSaveAdDetailsEvent) {
        details.marked = !details.marked;
        emit(UpdateSaveAdDetailsState());
        GetIt.I.get<AdRepository>().bookmark(details.id, details.marked);
      }
    });
  }

  AdModel details;
  LatLng position;
}
