import 'package:exservice/models/entity/ad_model.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:exservice/utils/global.dart';
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
              if (ad.extra.room != null)
                TextSpan(
                  text: '${ad.extra.room.value} ${ad.extra.room.unit}  ',
                  style: AppTextStyle.mediumBlueBold,
                ),
              if (ad.extra.bath != null)
                TextSpan(
                  text: '${ad.extra.bath.value} ${ad.extra.bath.unit}  ',
                  style: AppTextStyle.mediumBlueBold,
                ),
              if (ad.extra.size != null)
                TextSpan(
                  text:
                      '${ad.extra.size} ${AppLocalization.of(context).trans("meter")}',
                  style: AppTextStyle.mediumBlueBold,
                )
            ],
          ),
        ),
        Text(
          '${formatCurrency.format(ad.extra.price)} £',
          style: AppTextStyle.mediumBlueBold,
        ),
        getTitleWidget(context, ad.title),
        Text(
          '${ad.location.country}, ${ad.location.city}',
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

  Widget getTitleWidget(BuildContext context, String title) {
    if (title == null || title.isEmpty) {
      return Text(
        AppLocalization.of(context).trans("noDesc"),
        style: AppTextStyle.largeBlack,
      );
    } else {
      String text = title;
      int cutIndex = text.indexOf(' ');
      if (cutIndex < 0) {
        return Text(
          title,
          style: AppTextStyle.largeBlackBold,
          maxLines: 2,
        );
      } else {
        final head = text.substring(0, cutIndex);
        final tail = text.substring(cutIndex);
        return RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: head,
                style: AppTextStyle.largeBlackBold,
              ),
              TextSpan(
                text: tail,
                style: AppTextStyle.largeBlack,
              ),
            ],
          ),
        );
      }
    }
  }
}
