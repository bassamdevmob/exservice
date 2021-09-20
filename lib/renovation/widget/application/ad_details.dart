import 'package:exservice/models/common/AdModel.dart';
import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:exservice/renovation/utils/global.dart';
import 'package:exservice/widget/application/HelperWidgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatCurrency = NumberFormat.currency(name: "");

class AdDetails extends StatelessWidget {
  final AdModel ad;

  const AdDetails(this.ad, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            children: <TextSpan>[
              if (ad.attr.rooms != null)
                TextSpan(
                  text:
                      '${ad.attr.rooms.title} ${AppLocalization.of(context).trans("room")}  ',
                  style: AppTextStyle.mediumBlueBold,
                ),
              if (ad.attr.bath != null)
                TextSpan(
                  text:
                      '${ad.attr.bath.title} ${AppLocalization.of(context).trans("bath")}  ',
                  style: AppTextStyle.mediumBlueBold,
                ),
              if (ad.attr.size != null)
                TextSpan(
                  text: '${ad.attr.size} ${AppLocalization.of(context).trans("meter")}',
                  style: AppTextStyle.mediumBlueBold,
                )
            ],
          ),
        ),
        Text(
          '${formatCurrency.format(ad.attr.price)} £',
          style: AppTextStyle.mediumBlueBold,
        ),
        getTitleWidget(context, ad.title),
        Text(
          '${ad.town.country}, ${ad.town.name}',
          style: AppTextStyle.mediumGray,
          maxLines: 2,
        ),
        Text(
          isoFormatter.format(ad.createdAt),
          style: AppTextStyle.mediumGray,
        ),
      ],
    );
  }
}
