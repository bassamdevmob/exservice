import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:exservice/renovation/models/common/option_model.dart';
import 'package:exservice/renovation/utils/constant.dart';
import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
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
  OptionModel type;
  OptionModel room;
  OptionModel bath;
  OptionModel furniture;
  OptionModel security;
  OptionModel balcony;
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
  })
    ..add(OptionModel(
      id: faker.randomGenerator.integer(100),
      title: "More",
      image: faker.image.image(random: true, height: 300, width: 300),
    ));
  final List<OptionModel> balcony = List.generate(5, (index) {
    return OptionModel(
      id: faker.randomGenerator.integer(100),
      title: "${index + 1} balcony",
      image: faker.image.image(random: true, height: 300, width: 300),
    );
  })
    ..add(OptionModel(
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
  })
    ..add(OptionModel(
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
  final List<OptionModel> security = [
    OptionModel(
      id: faker.randomGenerator.integer(100),
      title: "Monitored Alarm",
      image: faker.image.image(random: true, height: 300, width: 300),
    ),
    OptionModel(
      id: faker.randomGenerator.integer(100),
      title: "Smoke Alarm",
      image: faker.image.image(random: true, height: 300, width: 300),
    ),
    OptionModel(
      id: faker.randomGenerator.integer(100),
      title: "Intruder Alarm",
      image: faker.image.image(random: true, height: 300, width: 300),
    ),
    OptionModel(
      id: faker.randomGenerator.integer(100),
      title: "CCTV Cameras",
      image: faker.image.image(random: true, height: 300, width: 300),
    ),
    OptionModel(
      id: faker.randomGenerator.integer(100),
      title: "Security Guard",
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

  PostAdBloc() : super(PostAdAwaitState()) {
    on((event, emit) async {
      if (event is FetchPostAdEvent) {
        var result = await PhotoManager.requestPermissionExtend();
        if (result.isAuth) {
          var paths = await PhotoManager.getAssetPathList(
            type: RequestType.common,
            onlyAll: true,
          );
          media = await paths.first.getAssetListPaged(page: 0, size: 80);
          selectedEntities.add(media.first);
          emit(PostAdAccessibleState());
        } else {
          // add(FetchPostAdEvent());
        }
      } else if (event is SelectMediaPostAdEvent) {
        if (selectedEntities.contains(event.entity)) {
          selectedEntities.remove(event.entity);
          placeholder = event.entity;
        } else {
          if (selectedEntities.length >= 10) {
            emit(PostAdReachedMediaMaxLimitsErrorState());
            return;
          }
          selectedEntities.add(event.entity);
        }
        emit(PostAdSelectMediaState());
      } else if (event is ChangeDisplayModePostAdEvent) {
        aspectRatioIndex++;
        if (aspectRatioIndex >= ratios.length) aspectRatioIndex = 0;
        emit(PostAdChangeDisplayModeState());
      } else if (event is ChangeGaragePostAdEvent) {
        snapshot.garage = event.value;
        emit(PostAdChangeOptionState());
      } else if (event is ChangeGymPostAdEvent) {
        snapshot.gym = event.value;
        emit(PostAdChangeOptionState());
      } else if (event is ChangeTerracePostAdEvent) {
        snapshot.terrace = event.value;
        emit(PostAdChangeOptionState());
      } else if (event is ChangeRoomPostAdEvent) {
        snapshot.room = event.value;
        emit(PostAdChangeOptionState());
      } else if (event is ChangeBathPostAdEvent) {
        snapshot.bath = event.value;
        emit(PostAdChangeOptionState());
      } else if (event is ChangeFurniturePostAdEvent) {
        snapshot.furniture = event.value;
        emit(PostAdChangeOptionState());
      } else if (event is ChangeTypePostAdEvent) {
        snapshot.type = event.value;
        emit(PostAdChangeOptionState());
      } else if (event is ChangeSecurityPostAdEvent) {
        snapshot.security = event.value;
        emit(PostAdChangeOptionState());
      } else if (event is ChangeBalconyPostAdEvent) {
        snapshot.balcony = event.value;
        emit(PostAdChangeOptionState());
      }
    });
  }

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
      return _thumbnails[entity] =
          await entity.thumbnailDataWithSize(ThumbnailSize.square(400));
    } else {
      return thumb;
    }
  }
}
