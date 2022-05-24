import 'package:exservice/renovation/models/entity/ad_model.dart';
import 'package:exservice/renovation/bloc/default/ad_details_bloc/ad_details_bloc.dart';
import 'package:exservice/renovation/controller/data_store.dart';
import 'package:exservice/renovation/layout/ad_details_layout.dart';
import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:exservice/renovation/utils/constant.dart';
import 'package:exservice/renovation/widget/application/global_widgets.dart';
import 'package:exservice/renovation/widget/button/favorite_button.dart';
import 'package:exservice/resources/api/ApiProviderDelegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:octo_image/octo_image.dart';

class GridAdCard extends StatefulWidget {
  final AdModel ad;

  const GridAdCard(this.ad, {Key key}) : super(key: key);

  @override
  State<GridAdCard> createState() => _GridAdCardState();
}

class _GridAdCardState extends State<GridAdCard> {
  void onSave() {
    setState(() {
      widget.ad.saved = !widget.ad.saved;
      GetIt.I
          .get<ApiProviderDelegate>()
          .fetchSaveAd(widget.ad.id, widget.ad.saved);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => AdDetailsBloc(widget.ad.id),
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
              String path = widget.ad.firstImage;
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
                  image: NetworkImage(widget.ad.firstImage),
                  progressIndicatorBuilder: (context, _) => simpleShimmer,
                  errorBuilder: (context, e, _) => Image.asset(
                    PLACEHOLDER,
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
                          text: '${widget.ad.attr.category.title}',
                          style: AppTextStyle.mediumBlackBold,
                        ),
                        TextSpan(
                          text:
                              ' ${widget.ad.attr.size} ${AppLocalization.of(context).trans("meter")}',
                          style: AppTextStyle.mediumBlack,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${widget.ad.attr.price} £',
                    style: AppTextStyle.mediumBlueBold,
                  ),
                ],
              );
              if (DataStore.instance.user.id == widget.ad.owner.id) {
                return body;
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: body,
                  ),
                  FavoriteButton(
                    active: widget.ad.saved,
                    onTap: onSave,
                  ),
                ],
              );
            }),
          )
        ],
      ),
    );
  }
}
