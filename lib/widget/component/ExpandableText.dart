import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;

  const ExpandableText(this.text, {Key key}) : super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool expand = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, layout) {
        final span = TextSpan(
          children: <InlineSpan>[
            TextSpan(
              text: AppLocalization.of(context).trans('desc'),
              style: AppTextStyle.largeBlackBold,
            ),
            TextSpan(
              text: widget.text,
              style: AppTextStyle.largeBlack,
            ),
          ],
        );
        final textPainter = TextPainter(
          maxLines: 2,
          text: span,
          textDirection: Directionality.of(context),
        );
        textPainter.layout(maxWidth: layout.maxWidth);
        if (textPainter.didExceedMaxLines) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RichText(
                maxLines: expand ? null : 2,
                text: span,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  child: Text(
                    AppLocalization.of(context).trans(expand ? "less" : "more"),
                    style: AppTextStyle.smallBlue
                        .copyWith(decoration: TextDecoration.underline),
                  ),
                  onTap: () {
                    setState(() {
                      expand = !expand;
                    });
                  },
                ),
              ),
            ],
          );
        } else {
          return RichText(
            maxLines: 2,
            text: span,
          );
        }
      },
    );
  }
}
