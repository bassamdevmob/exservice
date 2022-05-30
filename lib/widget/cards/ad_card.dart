import 'package:dio/dio.dart';
import 'package:exservice/bloc/profile_bloc/profile_bloc.dart';
import 'package:exservice/models/entity/ad_model.dart';
import 'package:exservice/bloc/ad_details_bloc/ad_details_bloc.dart';
import 'package:exservice/bloc/publisher_bloc/publisher_cubit.dart';
import 'package:exservice/layout/ad_details_layout.dart';
import 'package:exservice/layout/publisher_layout.dart';
import 'package:exservice/resources/repository/ad_repository.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/utils/sizer.dart';
import 'package:exservice/utils/utils.dart';
import 'package:exservice/widget/application/ad_details.dart';
import 'package:exservice/widget/application/ad_media.dart';
import 'package:exservice/widget/application/global_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:octo_image/octo_image.dart';

class AdCard extends StatefulWidget {
  final AdModel model;

  const AdCard(this.model, {Key key}) : super(key: key);

  @override
  State<AdCard> createState() => _AdCardState();
}

class _AdCardState extends State<AdCard> {
  bool awaitBookmark = false;

  void bookmark() async {
    try {
      setState(() => awaitBookmark = true);
      var response = await GetIt.I
          .get<AdRepository>()
          .bookmark(widget.model.id, !widget.model.marked);
      widget.model.marked = response.data;
      setState(() => awaitBookmark = false);
    } on DioError catch (ex) {
      Fluttertoast.showToast(
        msg: Utils.resolveErrorMessage(ex.error),
        toastLength: Toast.LENGTH_LONG,
      );
      setState(() => awaitBookmark = false);
    }
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
                  create: (context) => PublisherCubit(widget.model.owner.id),
                  child: PublisherLayout(),
                ),
              ),
            );
          },
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Sizer.hs3,
                  vertical: Sizer.vs3,
                ),
                child: ClipOval(
                  child: OctoImage(
                    width: Sizer.avatarSizeSmall,
                    height: Sizer.avatarSizeSmall,
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.model.owner.profilePicture),
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
                      widget.model.owner.username,
                      style: Theme.of(context).primaryTextTheme.bodyMedium,
                    ),
                    Text(
                      "${widget.model.owner.location.country} ${widget.model.owner.location.city}",
                      style: Theme.of(context).primaryTextTheme.bodyMedium,
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
                  create: (context) => AdDetailsBloc(widget.model.id),
                  child: AdDetailsLayout(),
                ),
              ),
            );
          },
          child: AdGallery(widget.model),
        ),
        Builder(builder: (context) {
          if (BlocProvider.of<ProfileBloc>(context).model.id ==
              widget.model.owner.id) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: AdDetails(widget.model),
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
                  child: AdDetails(widget.model),
                ),
                getBookmarkButton(),
              ],
            ),
          );
        }),
        Divider(color: AppColors.deepGray),
      ],
    );
  }

  Widget getBookmarkButton() {
    var color = Theme.of(context).iconTheme.color;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Icon(
        widget.model.marked ? Icons.bookmark : Icons.bookmark_outline,
        size: 25,
        color: awaitBookmark ? color.withOpacity(0.5) : color,
      ),
      onTap: awaitBookmark ? null : bookmark,
    );
  }
}
