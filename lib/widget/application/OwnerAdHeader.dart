import 'package:exservice/models/common/AdModel.dart';
import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/styles/app_colors.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:flutter/material.dart';

class OwnerAdHeader extends StatelessWidget {
  final AdModel ad;

  const OwnerAdHeader(this.ad, {Key key}) : super(key: key);

  Widget _getInfoWidget() {
    final children = [
      Text(
        ad.owner.name,
        textAlign: TextAlign.left,
        style: AppTextStyle.largeBlackBold,
      ),
    ];

    if (ad.owner.town != null) {
      children.add(Text(
        "${ad.owner.town.country}, ${ad.owner.town.name}",
        textAlign: TextAlign.left,
        style: AppTextStyle.largeBlack,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = 50;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 15, top: 10, bottom: 10, right: 10),
            width: width,
            height: width,
            decoration: BoxDecoration(
              border: Border.fromBorderSide(
                BorderSide(
                  color: AppColors.blue, // temp condition
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  "${ad.owner.profilePic}",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(child: _getInfoWidget()),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "${ad.totalViews}",
                  style: AppTextStyle.largeBlackBold,
                ),
                Text(
                  AppLocalization.of(context).trans('views'),
                  style: AppTextStyle.largeBlack,
                ),
              ],
            ),
          ),
          //image slider
        ],
      ),
    );
  }
}
