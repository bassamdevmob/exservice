import 'package:exservice/helper/AppConstant.dart';
import 'package:exservice/models/common/AdModel.dart';
import 'package:exservice/renovation/bloc/default/ad_details_bloc/ad_details_bloc.dart';
import 'package:exservice/renovation/controller/data_store.dart';
import 'package:exservice/renovation/layout/ad_details_layout.dart';
import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:exservice/renovation/widget/application/global_widgets.dart';
import 'package:exservice/widget/application/BookMark.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octo_image/octo_image.dart';

class GridAdCard extends StatelessWidget {
  final AdModel ad;

  const GridAdCard(this.ad, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => AdDetailsBloc(ad.id),
              child: AdDetailsLayout(),
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Builder(builder: (context) {
              String path = ad.firstImage;
              if (path == null) {
                return Center(
                  child: Text(
                    AppLocalization.of(context).trans('empty_media'),
                    style: AppTextStyle.mediumBlue,
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return SizedBox.expand(
                child: OctoImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(ad.firstImage),
                  progressIndicatorBuilder: (context, _) => simpleShimmer,
                  errorBuilder: (context, e, _) => Image.asset(
                    AppConstant.placeholder,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Builder(builder: (context) {
              final body = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RichText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '${ad.attr.category.title}',
                          style: AppTextStyle.mediumBlackBold,
                        ),
                        TextSpan(
                          text:
                              ' ${ad.attr.size} ${AppLocalization.of(context).trans("meter")}',
                          style: AppTextStyle.mediumBlack,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${ad.attr.price} £',
                    style: AppTextStyle.mediumBlueBold,
                  ),
                ],
              );
              if (DataStore.instance.user.id == ad.ownerId) {
                return body;
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: body,
                  ),
                  BookMark(ad.id, ad.saved),
                ],
              );
            }),
          )
        ],
      ),
    );
  }
}
