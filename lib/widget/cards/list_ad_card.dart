import 'package:exservice/bloc/profile_bloc/profile_bloc.dart';
import 'package:exservice/models/entity/ad_model.dart';
import 'package:exservice/bloc/ad_details_bloc/ad_details_bloc.dart';
import 'package:exservice/bloc/publisher_bloc/publisher_cubit.dart';
import 'package:exservice/layout/ad_details_layout.dart';
import 'package:exservice/layout/publisher_layout.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:exservice/utils/sizer.dart';
import 'package:exservice/widget/application/ad_details.dart';
import 'package:exservice/widget/application/ad_media.dart';
import 'package:exservice/widget/application/global_widgets.dart';
import 'package:exservice/widget/button/favorite_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octo_image/octo_image.dart';

class ListAdCard extends StatelessWidget {
  final AdModel ad;

  const ListAdCard(this.ad, {Key key}) : super(key: key);

  void onSave() {
    // setState(() {
    //   ad.marked = !ad.marked;
    //   GetIt.I
    //       .get<AdRepository>()
    //       .bookmark(ad.id, ad.marked);
    // });
  }

  @override
  Widget build(BuildContext context) {
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
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: Sizer.vs3,
                ),
                child: ClipOval(
                  child: OctoImage(
                    width: Sizer.avatarSizeSmall,
                    height: Sizer.avatarSizeSmall,
                    fit: BoxFit.cover,
                    image: NetworkImage(ad.owner.profilePicture),
                    progressIndicatorBuilder: (ctx, _) => simpleShimmer,
                    errorBuilder: imageErrorBuilder,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      ad.owner.username,
                      style: Theme.of(context).primaryTextTheme.bodyMedium,
                    ),
                    Text(
                      ad.owner.country,
                      style: Theme.of(context).primaryTextTheme.bodyMedium,
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
              CupertinoPageRoute(
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
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Builder(builder: (context) {
            if (BlocProvider.of<ProfileBloc>(context).model.id == ad.owner.id) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: AdDetails(ad),
              );
            }
            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: Sizer.vs3,
                horizontal: Sizer.vs3,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: AdDetails(ad),
                  ),
                  FavoriteButton(
                    active: ad.marked,
                    onTap: onSave,
                  ),
                ],
              ),
            );
          }),
        ),
        Divider(color: AppColors.deepGray),
      ],
    );
  }
}
