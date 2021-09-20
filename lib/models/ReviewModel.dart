import 'package:exservice/models/options/GetOptionsModel.dart';
import 'package:exservice/resources/ApiConstant.dart';
import 'package:flutter/material.dart';

class ReviewModel {
  String title;
  String description;
  double longitude;
  double latitude;

  Map<ConstOptions, Option> choices = {};
  DateTime date;
  List<ReviewMedia> media;
}

class NotificationValuesModel {
  String title;
  String description;
  double longitude;
  double latitude;

  Map<ConstOptions, Option> choices = {};
  Map<ConstOptions, RangeValues> ranges = {};
  DateTime date;
  List<ReviewMedia> media;
}

class ReviewMedia {
  String file;
  String compressed;
  int type;

  ReviewMedia(this.file, this.type);
}
