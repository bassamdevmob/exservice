import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/styles/app_colors.dart';
import 'package:exservice/renovation/styles/app_font_size.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:exservice/renovation/widget/application/global_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';

import '../../helper/AppConstant.dart';

Widget constructImageProvider(ImageProvider image,
    {Key key, Widget placeholder}) {
  return OctoImage(
    key: key,
    fit: BoxFit.cover,
    image: image,
    progressIndicatorBuilder: (context, progress) {
      return simpleShimmer;
    },
    errorBuilder: (context, error, stacktrace) =>
        placeholder ??
        Image.asset(
          AppConstant.placeholder,
          fit: BoxFit.cover,
        ),
  );
}

enum ReloadPlaceHolderType { ONE_LINE, RELOAD_BUTTON }

class ReloadPlaceHolder extends StatelessWidget {
  final Function onTap;
  final String text;
  final Color color;
  final ReloadPlaceHolderType type;

  const ReloadPlaceHolder({
    Key key,
    @required this.text,
    this.color,
    this.type = ReloadPlaceHolderType.RELOAD_BUTTON,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget widget;
    if (type == ReloadPlaceHolderType.ONE_LINE) {
      widget = InkWell(
        onTap: onTap,
        child: Text(
          '$text...${AppLocalization.of(context).trans('reload')}?',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: AppFontSize.MEDIUM,
            color: color,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      );
    } else {
      widget = Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppFontSize.MEDIUM,
              color: color,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            elevation: 5,
            onPressed: onTap,
            child: Icon(Icons.refresh),
          )
        ],
      );
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: widget,
      ),
    );
  }
}

Widget get dotsMenuIcon {
  final double dim = 12;
  final double pad = 15;
  final decoration = BoxDecoration(
    shape: BoxShape.circle,
    gradient: LinearGradient(
      colors: [AppColors.blue, AppColors.deepPurple],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );
  return Padding(
    padding: const EdgeInsets.only(left: 10),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: dim,
          height: dim,
          decoration: decoration,
        ),
        SizedBox(height: pad),
        Container(
          width: dim,
          height: dim,
          decoration: decoration,
        ),
        SizedBox(height: pad),
        Container(
          width: dim,
          height: dim,
          decoration: decoration,
        ),
      ],
    ),
  );
}

Widget getTitleWidget(BuildContext context, String title) {
  if (title == null || title.isEmpty) {
    return Text(
      AppLocalization.of(context).trans("noDesc"),
      style: AppTextStyle.largeBlack,
    );
  } else {
    String text = title;
    int cutIndex = text.indexOf(' ');
    if (cutIndex < 0) {
      return Text(
        title,
        style: AppTextStyle.largeBlackBold,
        maxLines: 2,
      );
    } else {
      final head = text.substring(0, cutIndex);
      final tail = text.substring(cutIndex);
      return RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: head,
              style: AppTextStyle.largeBlackBold,
            ),
            TextSpan(
              text: tail,
              style: AppTextStyle.largeBlack,
            ),
          ],
        ),
      );
    }
  }
}
