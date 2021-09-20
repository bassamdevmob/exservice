import 'package:exservice/models/options/GetOptionsModel.dart';
import 'package:exservice/resources/ApiConstant.dart';
import 'package:flutter/material.dart';

class InfoRange extends AdInfo {
  final int range;
  RangeValues values = RangeValues(0.0, 1.0);

  InfoRange(
    required, {
    locker,
    image,
    this.range,
  }) : super(required, locker, image);

  int get start => (values.start * range).round();

  int get end => (values.end * range).round();

  @override
  int get id => index == null ? null : index;

  @override
  String get curImage => image;

  @override
  String get title => '$start - $end';

  @override
  Option get option => Option(id: index, title: title);
}

class InfoSlider extends AdInfo {
  int range;

  // String extension;

  double value = 0.0;

  setValues(double value) {
    this.value = value;
    this.index = value == null ? null : (this.value * this.range).round();
  }

  InfoSlider(
    bool required, {
    ConstOptions locker,
    // this.extension = '',
    this.range = 1000000,
    String image,
  }) : super(required, locker, image);

  static InfoSlider parse(InfoSlider slider) => slider;

  @override
  int get id => index == null ? null : index;

  @override
  String get curImage => image;

  @override
  String get title => '$index';

  @override
  Option get option => Option(id: index, title: title);
}

class InfoPicker extends AdInfo {
  List<Option> options;

  InfoPicker(
    bool required, {
    ConstOptions locker,
    String image,
  }) : super(required, locker, image);

  static InfoPicker parse(InfoPicker picker) => picker;

  setValues(int index, {Option option, subOption}) {
    this.index = index;
    this._curOption = option;
    this._subOption = subOption;
  }

  Option _curOption;
  Option _subOption;

  Option get cur => _curOption;

  Option get sub => _subOption;

  @override
  int get id => _curOption == null ? null : _curOption.id;

  @override
  String get curImage => image;

  @override
  String get title {
    if (_curOption == null) {
      return _subOption.title;
    } else if (_subOption == null) {
      return _curOption.title;
    } else {
      return '${_curOption.title}, ${_subOption.title}';
    }
  }

  @override
  Option get option => _curOption;
}

abstract class AdInfo {
  final bool required;
  final ConstOptions locker;
  String image;

  int index;

  int get id;

  String get curImage;

  String get title;

  Option get option;

  AdInfo(this.required, this.locker, this.image);
}

class AdInfoManager {
  final Map<ConstOptions, AdInfo> current = {};
  final Map<ConstOptions, AdInfo> data;

  ConstOptions currentType;

  // String title = '';
  // String description = '';

  AdInfoManager(this.data);

  Option getOption(ConstOptions op) =>
      current[op] == null ? null : current[op].option;

  AdInfo get selectedInfo => data[currentType];
}
