import 'package:flutter/material.dart';
import 'package:exservice/utils/sizer.dart';

class InfoLayout extends StatelessWidget {
  final String title;
  final String content;

  const InfoLayout({
    Key key,
    this.title,
    this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: Sizer.scaffoldPadding,
        child: Text(
          content,
          style: Theme.of(context).primaryTextTheme.bodyMedium,
        ),
      ),
    );
  }
}
