import 'package:exservice/bloc/view/account_bloc/account_bloc.dart';
import 'package:exservice/models/entity/ad_model.dart';
import 'package:exservice/bloc/default/ad_details_bloc/ad_details_bloc.dart';
import 'package:exservice/controller/data_store.dart';
import 'package:exservice/layout/ad_details_layout.dart';
import 'package:exservice/resources/repository/ad_repository.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:exservice/utils/constant.dart';
import 'package:exservice/widget/application/global_widgets.dart';
import 'package:exservice/widget/button/favorite_button.dart';
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
      widget.ad.marked = !widget.ad.marked;
      GetIt.I
          .get<AdRepository>()
          .bookmark(widget.ad.id, widget.ad.marked);
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
            child: SizedBox.expand(
              child: OctoImage(
                fit: BoxFit.cover,
                image: NetworkImage(widget.ad.media.cover.link),
                progressIndicatorBuilder: (context, _) => simpleShimmer,
                errorBuilder: (context, e, _) => Image.asset(
                  PLACEHOLDER,
                  fit: BoxFit.cover,
                ),
              ),
            ),
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
                          text: '${widget.ad.extra.type.type}',
                          style: AppTextStyle.mediumBlackBold,
                        ),
                        TextSpan(
                          text:
                              ' ${widget.ad.extra.size.value} ${widget.ad.extra.size.unit}',
                          style: AppTextStyle.mediumBlack,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${widget.ad.extra.price.value} ${widget.ad.extra.price.unit}',
                    style: AppTextStyle.mediumBlueBold,
                  ),
                ],
              );
              if (BlocProvider.of<AccountBloc>(context).profile.id == widget.ad.owner.id) {
                return body;
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: body,
                  ),
                  FavoriteButton(
                    active: widget.ad.marked,
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
