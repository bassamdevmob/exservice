import 'package:exservice/models/entity/ad_model.dart';
import 'package:exservice/utils/global.dart';
import 'package:flutter/material.dart';

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
            style: Theme.of(context).primaryTextTheme.labelSmall,
            children: <TextSpan>[
              TextSpan(
                text: '${ad.extra.room.value} ${ad.extra.room.unit}  ',
              ),
              TextSpan(
                text: '${ad.extra.bath.value} ${ad.extra.bath.unit}  ',
              ),
              TextSpan(
                text: '${ad.extra.size.value} ${ad.extra.size.unit}',
              )
            ],
          ),
        ),
        Text(
          '${currencyFormatter.format(ad.extra.price.value)} ${ad.extra.price.unit}',
          style: Theme.of(context).primaryTextTheme.titleMedium,
        ),
        Text(
          ad.title,
          style: Theme.of(context).primaryTextTheme.bodyMedium,
        ),
        Text(
          '${ad.location.country}, ${ad.location.city}',
          style: Theme.of(context).primaryTextTheme.labelSmall,
          maxLines: 2,
        ),
        Text(
          isoFormatter.format(ad.createdAt),
          style: Theme.of(context).primaryTextTheme.labelSmall,
        ),
      ],
    );
  }

}
