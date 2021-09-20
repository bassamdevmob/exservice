import 'package:exservice/helper/AppConstant.dart';
import 'package:exservice/models/common/AdModel.dart';
import 'package:exservice/renovation/bloc/default/ad_details_bloc/ad_details_bloc.dart';
import 'package:exservice/renovation/bloc/default/publisher_bloc/publisher_cubit.dart';
import 'package:exservice/renovation/controller/data_store.dart';
import 'package:exservice/renovation/layout/ad_details_layout.dart';
import 'package:exservice/renovation/layout/publisher_layout.dart';
import 'package:exservice/renovation/styles/app_colors.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:exservice/renovation/widget/application/ad_details.dart';
import 'package:exservice/renovation/widget/application/ad_media.dart';
import 'package:exservice/renovation/widget/application/dotted_container.dart';
import 'package:exservice/widget/application/BookMark.dart';
import 'package:exservice/widget/component/AppShimmers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octo_image/octo_image.dart';

class ListAdCard extends StatelessWidget {
  final AdModel ad;

  const ListAdCard(this.ad, {Key key}) : super(key: key);

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
                  create: (context) => PublisherCubit(ad.owner.id),
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
                      image: NetworkImage(ad.owner.profilePic),
                      progressIndicatorBuilder: (ctx, _) =>
                          CustomShimmer.normal(),
                      errorBuilder: (ctx, e, _) => Image.asset(
                          AppConstant.placeholder,
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      ad.owner.name,
                      style: AppTextStyle.largeBlackBold,
                    ),
                    Text(
                      '${ad.owner.town.country}, ${ad.owner.town.name}',
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
                  create: (context) => AdDetailsBloc(ad.id),
                  child: AdDetailsLayout(),
                ),
              ),
            );
          },
          child: AdGallery(ad),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Builder(builder: (context) {
            if (DataStore.instance.user.id == ad.ownerId) {
              return AdDetails(ad);
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(child: AdDetails(ad)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: BookMark(ad.id, ad.saved),
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
