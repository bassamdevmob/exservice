import 'package:exservice/helper/AppConstant.dart';
import 'package:exservice/renovation/utils/constant.dart';
import 'package:exservice/renovation/bloc/default/ads_list_bloc/ads_list_cubit.dart';
import 'package:exservice/renovation/layout/ads_list_layout.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:exservice/renovation/widget/application/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octo_image/octo_image.dart';

class SummaryAdCard extends StatelessWidget {
  final String avatar;
  final String title;
  final List<String> images;

  const SummaryAdCard({
    Key key,
    this.avatar,
    this.title,
    this.images,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => AdsListCubit(),
              child: AdsListLayout(),
            ),
            settings: RouteSettings(name: AppConstant.markerPage),
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
            Padding(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: Container(
                  width: 70,
                  height: 70,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: OctoImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(avatar),
                    progressIndicatorBuilder: (context, progress) =>
                        simpleShimmer,
                    errorBuilder: (context, error, stacktrace) =>
                        Image.asset(PLACEHOLDER, fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyle.mediumBlackBold,
            ),
            SizedBox(height: 5),
            Expanded(child: getContent(context))
          ],
        ),
      ),
    );
  }

  Widget getImage(String image) {
    return OctoImage(
      fit: BoxFit.cover,
      image: NetworkImage(image),
      progressIndicatorBuilder: (context, progress) => simpleShimmer,
      errorBuilder: (context, error, stacktrace) =>
          Image.asset(PLACEHOLDER, fit: BoxFit.cover),
    );
  }

  Widget getContent(BuildContext context) {
    switch (images.length) {
      case 0:
        return Image.asset(PLACEHOLDER, fit: BoxFit.cover);
      case 1:
        return getImage(images[0]);
      case 2:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(child: getImage(images[0])),
            SizedBox(width: 2),
            Expanded(child: getImage(images[1])),
          ],
        );
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(child: getImage(images[0])),
            SizedBox(height: 2),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(child: getImage(images[1])),
                  SizedBox(width: 2),
                  Expanded(child: getImage(images[2])),
                ],
              ),
            ),
          ],
        );
    }
  }
}
