import 'dart:async';

import 'package:expandable/expandable.dart';
import 'package:exservice/models/common/AdModel.dart';
import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/styles/app_colors.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:exservice/renovation/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MoreAdInfo extends StatelessWidget {
  MoreAdInfo.fromAdAttribute(AdModel ad, LatLng position)
      : _option = ad.attr.option.title,
        _type = ad.attr.category.title,
        _furniture = ad.attr.furniture.title,
        _balcony = ad.attr.balcony?.title,
        _garage = ad.attr.garage?.title,
        _security = ad.attr.security,
        _terrace = ad.attr.terrace,
        _gym = ad.attr.gym,
        _available = ad.validtyDate,
        _createdAt = ad.createdAt,
        _position = position;

  final String _option;
  final String _type;
  final String _furniture;
  final String _balcony;
  final String _security;
  final String _garage;
  final String _terrace;
  final String _gym;
  final DateTime _createdAt;
  final DateTime _available;
  final LatLng _position;
  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ExpandablePanel(
            header: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                AppLocalization.of(context).trans('specifications'),
                style: AppTextStyle.mediumBlack,
              ),
            ),
            expanded: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Builder(builder: (context) {
                final children = <Widget>[
                  Divider(
                    height: 5,
                    color: AppColors.blue,
                  ),
                  SizedBox(height: 5),
                ];
                if (_option != null) {
                  children.add(
                    composeFeatureRow(
                      AppLocalization.of(context).trans('option'),
                      _option,
                    ),
                  );
                  children.add(Divider());
                }
                if (_type != null) {
                  children.add(
                    composeFeatureRow(
                      AppLocalization.of(context).trans('type'),
                      _type,
                    ),
                  );
                  children.add(Divider());
                }
                if (_furniture != null) {
                  children.add(
                    composeFeatureRow(
                      AppLocalization.of(context).trans('furniture'),
                      _furniture,
                    ),
                  );
                  children.add(Divider());
                }
                if (_balcony != null) {
                  children.add(
                    composeFeatureRow(
                      AppLocalization.of(context).trans('balcony'),
                      _balcony,
                    ),
                  );
                  children.add(Divider());
                }
                if (_garage != null) {
                  children.add(
                    composeFeatureRow(
                      AppLocalization.of(context).trans('garage'),
                      _garage,
                    ),
                  );
                  children.add(Divider());
                }
                if (_terrace != null) {
                  children.add(
                    composeFeatureRow(
                      AppLocalization.of(context).trans('terrace'),
                      AppLocalization.of(context)
                          .trans(_terrace == "0" ? "no" : "yes"),
                    ),
                  );
                  children.add(Divider());
                }
                if (_gym != null) {
                  children.add(
                    composeFeatureRow(
                      AppLocalization.of(context).trans('gym'),
                      AppLocalization.of(context)
                          .trans(_gym == "0" ? "no" : "yes"),
                    ),
                  );
                  children.add(Divider());
                }
                if (_security != null) {
                  children.add(
                    composeFeatureRow(
                      AppLocalization.of(context).trans('security'),
                      AppLocalization.of(context)
                          .trans(_security == "0" ? "no" : "yes"),
                    ),
                  );
                  children.add(Divider());
                }
                if (_createdAt != null) {
                  children.add(composeFeatureRow(
                    AppLocalization.of(context).trans('createdAt'),
                    isoFormatter.format(_createdAt),
                  ));
                  children.add(Divider());
                }
                if (_available != null) {
                  children.add(composeFeatureRow(
                    AppLocalization.of(context).trans('date'),
                    isoFormatter.format(_available),
                  ));
                  children.add(Divider());
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: children,
                );
              }),
            ),
          ),
          Divider(
            height: 1,
            color: AppColors.black,
          ),
          SizedBox(
            height: 10,
          ),
          ExpandablePanel(
            header: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                AppLocalization.of(context).trans('location'),
                style: AppTextStyle.mediumBlack,
              ),
            ),
            expanded: Builder(builder: (context) {
              if (_position == null) {
                return SizedBox(
                  height: 100,
                  child: Center(
                    child: Text(
                      AppLocalization.of(context).trans("location_not_available"),
                      style: AppTextStyle.largeBlack,
                    ),
                  ),
                );
              }
              return Container(
                width: MediaQuery.of(context).size.width,
                height: 170,
                child: GoogleMap(
                  key: UniqueKey(),
                  rotateGesturesEnabled: false,
                  scrollGesturesEnabled: false,
                  zoomGesturesEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  initialCameraPosition: CameraPosition(
                    target: _position,
                    zoom: 12.0,
                  ),
                  mapType: MapType.normal,
                  markers: Set.from([
                    Marker(
                      markerId: MarkerId('0'),
                      position: _position,
                    ),
                  ]),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget composeFeatureRow(String field, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          field,
          style: AppTextStyle.mediumBlack,
        ),
        Text(
          value,
          style: AppTextStyle.mediumBlack,
        )
      ],
    );
  }
}
