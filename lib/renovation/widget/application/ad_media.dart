import 'package:carousel_pro/carousel_pro.dart';
import 'package:exservice/helper/AppConstant.dart';
import 'package:exservice/models/common/AdModel.dart';
import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/styles/app_colors.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:exservice/renovation/utils/constant.dart';
import 'package:exservice/widget/application/AppVideo.dart';
import 'package:exservice/widget/component/AppShimmers.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';

class AdGallery extends StatelessWidget {
  final AdModel ad;

  const AdGallery(this.ad, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: ASPECT_RATIO,
      child: Builder(builder: (context) {
        final medias = ad.media;
        if (medias.isEmpty) {
          return Center(
            child: Text(
              AppLocalization.of(context).trans('empty_media'),
              style: AppTextStyle.largeBlueSatisfy,
              textAlign: TextAlign.center,
            ),
          );
        }
        return Carousel(
          images: List.generate(medias.length, (index) {
            if (medias[index].type == 2)
              return AppVideo.network('${medias[index].link}');
            return OctoImage(
              fit: BoxFit.cover,
              image: NetworkImage(medias[index].link),
              progressIndicatorBuilder: (ctx, _) => CustomShimmer.normal(),
              errorBuilder: (context, e, _) =>
                  Image.asset(AppConstant.placeholder, fit: BoxFit.cover),
            );
          }),
          boxFit: BoxFit.cover,
          autoplay: false,
          indicatorBgPadding: 10,
          dotColor: Colors.grey,
          dotIncreasedColor: AppColors.blue,
          dotBgColor: Colors.transparent,
          overlayShadowSize: 5.0,
          dotSpacing: 8,
          dotSize: 3.0,
        );
      }),
    );
  }
}
