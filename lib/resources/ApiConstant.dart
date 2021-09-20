import 'package:exservice/helper/Enums.dart';
import 'package:exservice/models/common/Town.dart';
import 'package:exservice/models/common/User.dart';
import 'package:exservice/models/options/AdPricesListModel.dart';
import 'package:exservice/models/options/GetCountriesListModel.dart';
import 'package:exservice/models/options/GetOptionsModel.dart';
import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

import 'api/ApiProviderDelegate.dart';

const kSizeRange = 100000.0;
const kPeriodRange = 99.0;
const kPerMonthRange = 20000.0;
const kPriceRange = 100000000.0;

class ConstOptions {
  final String name;
  final String image;
  final CategoryType type;

  ConstOptions(this.name, this.type, [this.image]);

  static final residential = ConstOptions("residential", CategoryType.picker);
  static final commercial = ConstOptions("commercial", CategoryType.picker);
  static final countries = ConstOptions("location", CategoryType.picker);
  static final furniture = ConstOptions("furniture", CategoryType.picker);
  static final options = ConstOptions("option", CategoryType.picker);
  static final price = ConstOptions("price", CategoryType.slider);
  static final size = ConstOptions("size", CategoryType.slider);
  static final balcony = ConstOptions("balcony", CategoryType.picker);
  static final garage = ConstOptions("garage", CategoryType.picker);
  static final room = ConstOptions("room", CategoryType.picker);
  static final bath = ConstOptions("bath", CategoryType.picker);
  static final security = ConstOptions("security", CategoryType.picker);
  static final terrace = ConstOptions("terrace", CategoryType.picker);
  static final gym = ConstOptions("gym", CategoryType.picker);

  static List<ConstOptions> get postAdOptions => [
        ConstOptions.options,
        ConstOptions.countries,
        ConstOptions.commercial,
        ConstOptions.residential,
        ConstOptions.furniture,
        ConstOptions.bath,
        ConstOptions.balcony,
        ConstOptions.room,
        ConstOptions.garage,
        ConstOptions.terrace,
        ConstOptions.gym,
        ConstOptions.security,
      ];

  static List<ConstOptions> get filters => [
        ConstOptions.options,
        ConstOptions.countries,
        ConstOptions.commercial,
        ConstOptions.residential,
        ConstOptions.room,
        ConstOptions.price,
        ConstOptions.size,
        ConstOptions.furniture,
        ConstOptions.garage,
        ConstOptions.terrace,
        ConstOptions.bath,
        ConstOptions.balcony,
      ];
}

class ApiConstant {
  static final ApiConstant _apiConstant = new ApiConstant._internal();

  factory ApiConstant.instance() => _apiConstant;

  ApiConstant._internal();

  final Map<ConstOptions, List<Option>> options = {};
  List<UserType> userTypes;
  List<Town> towns;
  List<Choice> countries;
  List<AdPrice> prices;

  bool _initialized = false;

  bool get initialized => _initialized;

  Future<void> initialize(BuildContext context) async {
    if (_initialized) {
      return;
    } else {
      final List<Future> futures = [];

      ///user types
      if (userTypes == null)
        futures.add(Future(() async {
          userTypes = await GetIt.I
              .get<ApiProviderDelegate>()
              .fetchUserTypesList(context);
        }));

      ///payment
      if (prices == null)
        futures.add(Future(() async {
          prices = await GetIt.I
              .get<ApiProviderDelegate>()
              .fetchAdPricesList(context);
        }));

      ///location
      if (options[ConstOptions.countries] == null)
        futures.add(Future(() async {
          countries = await GetIt.I
              .get<ApiProviderDelegate>()
              .fetchCountriesList(context);
          towns = await GetIt.I
              .get<ApiProviderDelegate>()
              .fetchTownsList(context, countries.first.id);
          options[ConstOptions.countries] =
              List<Option>.from(towns.map((x) => Option(
                    id: x.id,
                    title: x.name,
                    image: x.image,
                  )));
        }));

      ///types
      if (options[ConstOptions.residential] == null)
        futures.add(Future(() async {
          options[ConstOptions.residential] = await GetIt.I
              .get<ApiProviderDelegate>()
              .fetchGetTypesOptions(context, ConstOptions.residential);
        }));
      if (options[ConstOptions.commercial] == null)
        futures.add(Future(() async {
          options[ConstOptions.commercial] = await GetIt.I
              .get<ApiProviderDelegate>()
              .fetchGetTypesOptions(context, ConstOptions.commercial);
        }));

      ///normal
      if (options[ConstOptions.furniture] == null)
        futures.add(Future(() async {
          options[ConstOptions.furniture] = await GetIt.I
              .get<ApiProviderDelegate>()
              .fetchGetOptions(context, ConstOptions.furniture);
        }));
      if (options[ConstOptions.options] == null)
        futures.add(Future(() async {
          options[ConstOptions.options] = await GetIt.I
              .get<ApiProviderDelegate>()
              .fetchGetOptions(context, ConstOptions.options);
        }));

      ///numerical
      if (options[ConstOptions.bath] == null)
        futures.add(Future(() async {
          options[ConstOptions.bath] = await GetIt.I
              .get<ApiProviderDelegate>()
              .fetchGetNumericalOptions(context, ConstOptions.bath);
        }));
      if (options[ConstOptions.balcony] == null)
        futures.add(Future(() async {
          options[ConstOptions.balcony] = await GetIt.I
              .get<ApiProviderDelegate>()
              .fetchGetNumericalOptions(context, ConstOptions.balcony);
        }));
      if (options[ConstOptions.room] == null)
        futures.add(Future(() async {
          options[ConstOptions.room] = await GetIt.I
              .get<ApiProviderDelegate>()
              .fetchGetNumericalOptions(context, ConstOptions.room);
        }));
      if (options[ConstOptions.garage] == null)
        futures.add(Future(() async {
          options[ConstOptions.garage] = await GetIt.I
              .get<ApiProviderDelegate>()
              .fetchGetNumericalOptions(context, ConstOptions.garage);
        }));

      ///yes/no
      final chooseYesNo = [
        Option(id: 1, title: AppLocalization.of(context).trans('yes')),
        Option(id: 0, title: AppLocalization.of(context).trans('no'))
      ];
      if (options[ConstOptions.security] == null)
        options[ConstOptions.security] = chooseYesNo;
      if (options[ConstOptions.terrace] == null)
        options[ConstOptions.terrace] = chooseYesNo;
      if (options[ConstOptions.gym] == null)
        options[ConstOptions.gym] = chooseYesNo;

      await Future.wait(futures);
      _initialized = true;
      return;
    }
  }
}

final apiConstant = ApiConstant.instance();
