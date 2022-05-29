import 'package:carousel_pro/carousel_pro.dart';
import 'package:exservice/utils/constant.dart';
import 'package:exservice/models/entity/ad_model.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/utils/enums.dart';
import 'package:exservice/widget/application/global_widgets.dart';
import 'package:exservice/widget/application/app_video.dart';
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
        return Carousel(
          images: List.generate(
            medias.gallery.length,
            (index) {
              if (medias.gallery[index].type == MediaType.image.name) {
                return OctoImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(medias.gallery[index].link),
                  progressIndicatorBuilder: (ctx, _) => simpleShimmer,
                  errorBuilder: imageErrorBuilder,
                );
              }
              return AppVideo.network('${medias.gallery[index].link}');
            },
          ),
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
