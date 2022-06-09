import 'dart:typed_data';

import 'package:exservice/bloc/post/info_bloc/compose_details_cubit.dart';
import 'package:exservice/bloc/post/media_picker_bloc/compose_media_picker_bloc.dart';
import 'package:exservice/models/entity/ad_model.dart';
import 'package:exservice/models/entity/location.dart';
import 'package:exservice/models/response/config_response.dart';
import 'package:exservice/utils/enums.dart';
import 'package:exservice/widget/bottom_sheets/numeric_input_bottom_sheet.dart';
import 'package:exservice/widget/bottom_sheets/option_picker_bottom_sheet.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photo_manager/photo_manager.dart' hide LatLng;

class CompositionRepository {
  AspectRatioMode _mode;
  List<AssetEntity> _entities;
  Uint8List _thumbnail;

  Config get config => _config;
  Config _config;
  OptionResult _type;
  OptionResult _trade;
  LatLng _location;
  NumericResult _size;
  NumericResult _price;
  List<String> _notes;

  AspectRatioMode get mode => _mode;

  Uint8List get thumbnail => _thumbnail;

  void setMedia(ComposeMediaPickerBloc bloc) {
    _mode = bloc.mode;
    _entities = bloc.selectedEntities;
    _thumbnail = bloc.thumbnail;
  }

  void setDetails(ComposeDetailsCubit bloc) {
    _config = bloc.data;
    _type = bloc.type;
    _trade = bloc.trade;
    _location = bloc.location;
    _size = bloc.size;
    _price = bloc.price;
  }

  void setNotes(List<String> notes) {
    _notes = notes;
  }

  AdModel toModel() {
    return AdModel(
      id: 0,
      views: 3040,
      status: AdStatus.active.name,
      marked: false,
      createdAt: DateTime.now(),
      type: OptionData(
        text: _type.option.text,
        value: _type.option.value,
        note: _type.note,
      ),
      trade: OptionData(
        text: _trade.option.text,
        value: _trade.option.value,
        note: _trade.note,
      ),
      location: Location(
        latitude: _location.latitude.toString(),
        longitude: _location.longitude.toString(),
        city: "Berlin",
        country: "Germany",
      ),
      size: NumericData(
        unit: _size.unit,
        value: _size.value,
        note: _size.note,
      ),
      price: NumericData(
        unit: _price.unit,
        value: _price.value,
        note: _price.note,
      ),
      extra: _notes,
    );
  }
}
