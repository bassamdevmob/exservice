import 'package:exservice/models/entity/ad_model.dart';
import 'package:exservice/utils/global.dart';
import 'package:flutter/material.dart';

class AdDetails extends StatelessWidget {
  final AdModel model;

  const AdDetails(this.model, {Key key}) : super(key: key);

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
                text: '${model.trade.text}  ',
              ),
              TextSpan(
                text: '${model.type.text}  ',
              ),
              TextSpan(
                text: '${model.size.value} ${model.size.unit.value}',
              )
            ],
          ),
        ),
        Text(
          '${currencyFormatter.format(model.price.value)} ${model.price.unit.value}',
          style: Theme.of(context).primaryTextTheme.titleMedium,
        ),
        Text(
          model.title,
          style: Theme.of(context).primaryTextTheme.bodyMedium,
        ),
        Text(
          '${model.location.country}, ${model.location.city}',
          style: Theme.of(context).primaryTextTheme.labelSmall,
        ),
        Text(
          isoFormatter.format(model.createdAt),
          style: Theme.of(context).primaryTextTheme.labelSmall,
        ),
      ],
    );
  }
}
