import 'package:exservice/models/options/GetOptionsModel.dart';
import 'package:exservice/resources/ApiConstant.dart';
import 'package:flutter/material.dart';

class FilterSlider extends Filter {
  final double range;
  RangeValues values = RangeValues(0.0, 1.0);

  FilterSlider(String label, this.range) : super(label);

  int get start => (values.start * range).round();

  int get end => (values.end * range).round();
}

class Filter {
  final String label;

  int index;
  List<Option> options = [];

  Filter(this.label);

  int get currentId => index == null ? null : options[index].id;

  String get currentTitle => index == null ? null : options[index].title;
}

class FiltersManager {
  final Map<ConstOptions, Filter> filters = {};

  ConstOptions currentFilterType;

  Filter get currentFilter => filters[currentFilterType];

  int getId(ConstOptions op) =>
      filters[op] == null ? null : filters[op].currentId;
}
