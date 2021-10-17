import 'package:exservice/renovation/models/common/ad_model.dart';
import 'package:exservice/renovation/bloc/default/ad_details_bloc/ad_details_bloc.dart';
import 'package:exservice/renovation/bloc/default/publisher_bloc/publisher_cubit.dart';
import 'package:exservice/renovation/controller/data_store.dart';
import 'package:exservice/renovation/layout/ad_details_layout.dart';
import 'package:exservice/renovation/layout/publisher_layout.dart';
import 'package:exservice/renovation/styles/app_colors.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:exservice/renovation/utils/constant.dart';
import 'package:exservice/renovation/widget/application/ad_details.dart';
import 'package:exservice/renovation/widget/application/ad_media.dart';
import 'package:exservice/renovation/widget/application/dotted_container.dart';
import 'package:exservice/renovation/widget/application/global_widgets.dart';
import 'package:exservice/renovation/widget/button/favorite_button.dart';
import 'package:exservice/resources/api/ApiProviderDelegate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:octo_image/octo_image.dart';

class ListAdCard extends StatefulWidget {
  final AdModel ad;

  const ListAdCard(this.ad, {Key key}) : super(key: key);

  @override
  State<ListAdCard> createState() => _ListAdCardState();
}

class _ListAdCardState extends State<ListAdCard> {
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
    double size = 50;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => PublisherCubit(widget.ad.owner.id),
                  child: PublisherLayout(),
                ),
              ),
            );
          },
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: OutlineContainer(
                  gradient: LinearGradient(
                    colors: [AppColors.blue, AppColors.deepPurple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  strokeWidth: 1,
                  radius: size / 2,
                  dimension: size,
                  child: ClipOval(
                    child: OctoImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(widget.ad.owner.profilePic),
                      progressIndicatorBuilder: (ctx, _) => simpleShimmer,
                      errorBuilder: (ctx, e, _) =>
                          Image.asset(PLACEHOLDER, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.ad.owner.username,
                      style: AppTextStyle.largeBlackBold,
                    ),
                    Text(
                      '${widget.ad.owner.town.country}, ${widget.ad.owner.town.name}',
                      style: AppTextStyle.largeBlack,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => AdDetailsBloc(widget.ad.id),
                  child: AdDetailsLayout(),
                ),
              ),
            );
          },
          child: AdGallery(widget.ad),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Builder(builder: (context) {
            if (DataStore.instance.user.id == widget.ad.owner.id) {
              return AdDetails(widget.ad);
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(child: AdDetails(widget.ad)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: FavoriteButton(
                    active: widget.ad.saved,
                    onTap: onSave,
                  ),
                ),
              ],
            );
          }),
        ),
        Divider(color: AppColors.deepGray),
      ],
    );
  }
}
