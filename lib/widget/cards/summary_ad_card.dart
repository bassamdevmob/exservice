import 'package:exservice/bloc/ads_bloc/ads_cubit.dart';
import 'package:exservice/layout/ads_layout.dart';
import 'package:exservice/models/entity/ad_model.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/utils/sizer.dart';
import 'package:exservice/widget/application/global_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octo_image/octo_image.dart';

class SummaryAdCard extends StatelessWidget {
  final AdModel model;

  const SummaryAdCard(
    this.model, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => AdsCubit(),
              child: AdsLayout(),
            ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        elevation: 5,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ClipOval(
                      child: OctoImage(
                        width: Sizer.avatarSizeLarge,
                        height: Sizer.avatarSizeLarge,
                        fit: BoxFit.cover,
                        image: NetworkImage(model.owner.profilePicture),
                        progressIndicatorBuilder: (context, progress) =>
                            simpleShimmer,
                        errorBuilder: imageErrorBuilder,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model.title,
                          style: Theme.of(context).primaryTextTheme.bodyMedium,
                        ),
                        Text(
                          "${model.location.country} ${model.location.city}",
                          maxLines: 1,
                          style: Theme.of(context).primaryTextTheme.bodyMedium,
                        ),
                        Text(
                          model.owner.username,
                          style: Theme.of(context).primaryTextTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: getContent(context),
            )
          ],
        ),
      ),
    );
  }

  Widget getImage(BaseMedia image) {
    return OctoImage(
      fit: BoxFit.cover,
      image: resolveProvider(image),
      progressIndicatorBuilder: (context, progress) => simpleShimmer,
      errorBuilder: imageErrorBuilder,
    );
  }

  Widget getContent(BuildContext context) {
    switch (model.media.length) {
      case 0:
        return ColoredBox(
          color: AppColors.blue,
        );
      case 1:
        return getImage(model.media[0]);
      case 2:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(child: getImage(model.media[0])),
            SizedBox(width: 2),
            Expanded(child: getImage(model.media[1])),
          ],
        );
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(child: getImage(model.media[0])),
            SizedBox(height: 2),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(child: getImage(model.media[1])),
                  SizedBox(width: 2),
                  Expanded(child: getImage(model.media[2])),
                ],
              ),
            ),
          ],
        );
    }
  }
}
