import 'dart:io';

import 'package:exservice/helper/AppConstant.dart';
import 'package:exservice/models/ReviewModel.dart';
import 'package:exservice/models/common/AdModel.dart';
import 'package:exservice/renovation/controller/data_store.dart';
import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/styles/app_colors.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:exservice/renovation/utils/constant.dart';
import 'package:exservice/renovation/utils/global.dart';
import 'package:exservice/renovation/widget/button/app_button.dart';
import 'package:exservice/resources/ApiConstant.dart';
import 'package:exservice/ui/post_ad/CompletePublishAd.dart';
import 'package:exservice/widget/application/AppVideo.dart';
import 'package:exservice/widget/application/MoreAdInfo.dart';
import 'package:exservice/widget/application/OwnerAdHeader.dart';
import 'package:exservice/widget/component/ExpandableText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ReviewAdDetailsPage extends StatefulWidget {
  final ReviewModel details;

  const ReviewAdDetailsPage(this.details, {Key key}) : super(key: key);

  @override
  _ReviewAdDetailsPageState createState() => _ReviewAdDetailsPageState();
}

class _ReviewAdDetailsPageState extends State<ReviewAdDetailsPage> {
  LatLng position;

  @override
  void initState() {
    position = LatLng(51.509865, -0.118092);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final date = DateTime.now();
    return Scaffold(
      // key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        iconTheme: IconThemeData(color: AppColors.blue),
        centerTitle: true,
        title: Text(
          AppLocalization.of(context).trans('app_name'),
          style: AppTextStyle.largeBlack,
        ),
      ),
      body: ListView(
        children: <Widget>[
          OwnerAdHeader(
            AdModel(
              owner: DataStore.instance.user,
              totalViews: 0,
            ),
          ),
          AspectRatio(
            aspectRatio: ASPECT_RATIO,
            child: Builder(
              builder: (context) {
                if (widget.details.media.isEmpty) {
                  return Center(
                    child: Text(
                      AppLocalization.of(context).trans('empty_media'),
                      style: AppTextStyle.mediumBlue,
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return Swiper(
                  itemCount: widget.details.media.length,
                  loop: false,
                  pagination: SwiperPagination(),
                  itemBuilder: (BuildContext context, index) {
                    if (widget.details.media[index].type == 1) {
                      return Image.file(
                        File(widget.details.media[index].file),
                        fit: BoxFit.cover,
                      );
                    } else {
                      return Center(
                        child: AppVideo.file(
                          File(widget.details.media[index].file),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Builder(builder: (context) {
                    final children = <Widget>[];
                    final richChildren = <TextSpan>[];
                    if (widget.details.choices[ConstOptions.room] != null) {
                      richChildren.add(TextSpan(
                        text:
                            '${widget.details.choices[ConstOptions.room].title} ${AppLocalization.of(context).trans("room")}  ',
                        style: AppTextStyle.mediumBlackBold,
                      ));
                    }
                    if (widget.details.choices[ConstOptions.bath] != null) {
                      richChildren.add(TextSpan(
                        text:
                            '${widget.details.choices[ConstOptions.bath].title} ${AppLocalization.of(context).trans("bath")}  ',
                        style: AppTextStyle.mediumBlackBold,
                      ));
                    }
                    if (widget.details.choices[ConstOptions.size] != null) {
                      richChildren.add(TextSpan(
                        text:
                            '${widget.details.choices[ConstOptions.size].title} Inch',
                        style: AppTextStyle.mediumBlackBold,
                      ));
                    }
                    if (richChildren.isNotEmpty) {
                      children.add(RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          children: richChildren,
                        ),
                      ));
                    }

                    children.add(Text(
                      '${widget.details.choices[ConstOptions.price].title}',
                      textAlign: TextAlign.left,
                      style: AppTextStyle.mediumBlueBold,
                    ));

                    children.add(ExpandableText(widget.details.description));

                    if (widget.details.choices[ConstOptions.countries] !=
                        null) {
                      children.add(Text(
                        '${widget.details.choices[ConstOptions.countries].title}',
                        textAlign: TextAlign.left,
                        style: AppTextStyle.mediumBlack,
                      ));
                    }
                    children.add(SizedBox(height: 5));
                    children.add(Text(
                      isoFormatter.format(date),
                      textAlign: TextAlign.left,
                      style: AppTextStyle.smallGray,
                    ));

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: children,
                    );
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SvgPicture.asset(
                    AppConstant.bookmarkSvg,
                    semanticsLabel: 'bookmark',
                  ),
                ),
              ],
            ),
          ),
          MoreAdInfo.fromReviewModel(widget.details, position),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: AppButton(
                    child: Text(
                      AppLocalization.of(context).trans('back'),
                      style: AppTextStyle.largeBlack,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: AppButton(
                    child: Text(
                      AppLocalization.of(context).trans('publish'),
                      style: AppTextStyle.largeBlack,
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                            builder: (context) =>
                                CompletePublishAd(widget.details)),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
