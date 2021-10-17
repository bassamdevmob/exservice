import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:exservice/renovation/models/common/option_model.dart';
import 'package:exservice/renovation/utils/constant.dart';
import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:photo_manager/photo_manager.dart';

part 'post_ad_event.dart';

part 'post_ad_state.dart';

class AspectRatioSnapshot {
  final String id;
  final double value;

  const AspectRatioSnapshot(this.id, this.value);
}

class PostAdAttributes {
  bool garage;
  bool terrace;
  bool gym;
  OptionModel room;
  OptionModel bath;
  OptionModel furniture;
}

const ratios = [
  AspectRatioSnapshot("WIDE", ASPECT_RATIO),
  AspectRatioSnapshot("TIGHT", 1.1),
];

class DataCenter {
  final List<OptionModel> baths = List.generate(5, (index) {
    return OptionModel(
      id: faker.randomGenerator.integer(100),
      title: "${index + 1} Bathroom",
      image: faker.image.image(random: true, height: 300, width: 300),
    );
  })..add(OptionModel(
    id: faker.randomGenerator.integer(100),
    title: "More",
    image: faker.image.image(random: true, height: 300, width: 300),
  ));
  final List<OptionModel> rooms = List.generate(10, (index) {
    return OptionModel(
      id: faker.randomGenerator.integer(100),
      title: "${index + 1} Room",
      image: faker.image.image(random: true, height: 300, width: 300),
    );
  })..add(OptionModel(
    id: faker.randomGenerator.integer(100),
    title: "More",
    image: faker.image.image(random: true, height: 300, width: 300),
  ));
  final List<OptionModel> options = [
    OptionModel(
      id: faker.randomGenerator.integer(100),
      title: "Sell",
      image: faker.image.image(random: true, height: 300, width: 300),
    ),
    OptionModel(
      id: faker.randomGenerator.integer(100),
      title: "Rent",
      image: faker.image.image(random: true, height: 300, width: 300),
    ),
    OptionModel(
      id: faker.randomGenerator.integer(100),
      title: "Contract",
      image: faker.image.image(random: true, height: 300, width: 300),
    ),
    OptionModel(
      id: faker.randomGenerator.integer(100),
      title: "Other",
      image: faker.image.image(random: true, height: 300, width: 300),
    ),
  ];
  final List<OptionModel> types = [
    OptionModel(
      id: faker.randomGenerator.integer(100),
      title: "Land",
      image: faker.image.image(random: true, height: 300, width: 300),
    ),
    OptionModel(
      id: faker.randomGenerator.integer(100),
      title: "Residential",
      image: faker.image.image(random: true, height: 300, width: 300),
    ),
    OptionModel(
      id: faker.randomGenerator.integer(100),
      title: "Commercial",
      image: faker.image.image(random: true, height: 300, width: 300),
    ),
    OptionModel(
      id: faker.randomGenerator.integer(100),
      title: "Industrial",
      image: faker.image.image(random: true, height: 300, width: 300),
    ),
  ];
  final List<OptionModel> furniture = [
    OptionModel(
      id: faker.randomGenerator.integer(100),
      title: "Furnished",
      image: faker.image.image(random: true, height: 300, width: 300),
    ),
    OptionModel(
      id: faker.randomGenerator.integer(100),
      title: "Unfurnished",
      image: faker.image.image(random: true, height: 300, width: 300),
    ),
    OptionModel(
      id: faker.randomGenerator.integer(100),
      title: "Super Deluxe",
      image: faker.image.image(random: true, height: 300, width: 300),
    ),
    OptionModel(
      id: faker.randomGenerator.integer(100),
      title: "Deluxe",
      image: faker.image.image(random: true, height: 300, width: 300),
    ),
  ];
}

class PostAdBloc extends Bloc<PostAdEvent, PostAdState> {
  final titleController = TextEditingController();
  final detailsController = TextEditingController();
  final List<AssetEntity> selectedEntities = [];
  final PostAdAttributes snapshot = PostAdAttributes();
  final DataCenter dataCenter = DataCenter();

  List<AssetEntity> media;
  AssetEntity placeholder;

  int aspectRatioIndex = 0;

  AspectRatioSnapshot get aspectRatio => ratios[aspectRatioIndex];

  List<AssetEntity> getSelectedMedias() => selectedEntities.isNotEmpty
      ? selectedEntities
      : <AssetEntity>[placeholder];

  PostAdBloc() : super(PostAdAwaitState());

  @override
  Future<void> close() {
    titleController.dispose();
    detailsController.dispose();
    return super.close();
  }

  final _thumbnails = <AssetEntity, Uint8List>{};

  Uint8List get thumbnail => _thumbnails[selectedEntities.first];

  Future<Uint8List> getThumbnail(AssetEntity entity) async {
    var thumb = _thumbnails[entity];
    if (thumb == null) {
      return _thumbnails[entity] = await entity.thumbDataWithSize(400, 400);
    } else {
      return thumb;
    }
  }

  @override
  Stream<PostAdState> mapEventToState(
    PostAdEvent event,
  ) async* {
    if (event is FetchPostAdEvent) {
      var isGranted = await PhotoManager.requestPermission();
      if (isGranted) {
        var paths = await PhotoManager.getAssetPathList(
          type: RequestType.common,
          onlyAll: true,
        );
        media = await paths.first.assetList;
        selectedEntities.add(media.first);
        yield PostAdAccessibleState();
      } else {
        // add(FetchPostAdEvent());
      }
    } else if (event is SelectMediaPostAdEvent) {
      if (selectedEntities.contains(event.entity)) {
        selectedEntities.remove(event.entity);
        placeholder = event.entity;
      } else {
        if (selectedEntities.length >= 10) {
          yield PostAdReachedMediaMaxLimitsErrorState();
          return;
        }
        selectedEntities.add(event.entity);
      }
      yield PostAdSelectMediaState();
    } else if (event is ChangeDisplayModePostAdEvent) {
      aspectRatioIndex++;
      if (aspectRatioIndex >= ratios.length) aspectRatioIndex = 0;
      yield PostAdChangeDisplayModeState();
    } else if (event is ChangeGaragePostAdEvent) {
      snapshot.garage = event.value;
      yield PostAdChangeOptionState();
    } else if (event is ChangeGymPostAdEvent) {
      snapshot.gym = event.value;
      yield PostAdChangeOptionState();
    } else if (event is ChangeTerracePostAdEvent) {
      snapshot.terrace = event.value;
      yield PostAdChangeOptionState();
    } else if (event is ChangeRoomPostAdEvent) {
      snapshot.room = event.value;
      yield PostAdChangeOptionState();
    } else if (event is ChangeBathPostAdEvent) {
      snapshot.bath = event.value;
      yield PostAdChangeOptionState();
    } else if (event is ChangeFurniturePostAdEvent) {
      snapshot.furniture = event.value;
      yield PostAdChangeOptionState();
    }
  }
}
