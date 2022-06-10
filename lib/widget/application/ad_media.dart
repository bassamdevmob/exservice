import 'package:exservice/utils/constant.dart';
import 'package:exservice/models/entity/ad_model.dart';
import 'package:exservice/utils/global.dart';
import 'package:exservice/widget/application/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:octo_image/octo_image.dart';

class AdGallery extends StatelessWidget {
  final AdModel model;

  const AdGallery(this.model, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: ASPECT_RATIO,
      child: Builder(builder: (context) {
        final media = model.media;
        return Swiper(
          itemCount: media.length,
          pagination: swiperPagination,
          itemBuilder: (context, index) {
            return OctoImage(
              fit: BoxFit.cover,
              image: resolveProvider(media[index]),
              progressIndicatorBuilder: (ctx, _) => simpleShimmer,
              errorBuilder: imageErrorBuilder,
            );
          },
        );
      }),
    );
  }
}
