import 'dart:typed_data';

import 'package:exservice/bloc/post/media_picker_bloc/compose_media_picker_bloc.dart';
import 'package:exservice/models/entity/ad_model.dart';
import 'package:exservice/models/entity/location.dart';
import 'package:exservice/models/entity/user.dart';
import 'package:exservice/utils/enums.dart';
import 'package:exservice/widget/bottom_sheets/numeric_input_bottom_sheet.dart';
import 'package:exservice/widget/bottom_sheets/option_picker_bottom_sheet.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photo_manager/photo_manager.dart' hide LatLng;

class CompositionRepository {
  AspectRatioMode mode = AspectRatioMode.square;
  List<AssetEntity> entities = [];
  Map<AssetEntity, Uint8List> thumbnails = {};

  String title;
  String description;
  LatLng location;
  OptionResult type;
  OptionResult trade;
  NumericResult price;
  NumericResult size;
  List<String> notes = [];

  Uint8List get thumbnail => thumbnails[entities.first];

  AdModel toModel(User user) {
    return AdModel(
      id: 0,
      views: 3040,
      title: title,
      description: description,
      owner: user,
      media: entities
          .map((e) => ReviewMedia(id: e.hashCode, data: thumbnails[e]))
          .toList(),
      status: AdStatus.active.name,
      marked: false,
      createdAt: DateTime.now(),
      type: OptionData(
        text: type.option.text,
        value: type.option.value,
        note: type.note,
      ),
      trade: OptionData(
        text: trade.option.text,
        value: trade.option.value,
        note: trade.note,
      ),
      location: Location(
        latitude: location.latitude.toString(),
        longitude: location.longitude.toString(),
        city: "Berlin",
        country: "Germany",
      ),
      size: NumericData(
        unit: size.unit,
        value: size.value,
        note: size.note,
      ),
      price: NumericData(
        unit: price.unit,
        value: price.value,
        note: price.note,
      ),
      extra: notes,
    );
  }
}
