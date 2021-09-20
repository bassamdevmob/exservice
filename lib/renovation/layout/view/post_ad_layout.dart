import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/styles/app_colors.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostAdLayout extends StatefulWidget {
  @override
  _PostAdLayoutState createState() => _PostAdLayoutState();
}

class _PostAdLayoutState extends State<PostAdLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        children: [
          getSelector(),
        ],
      ),
    );
  }

  Widget getSelector(){
    return ListTile(
      title: Text(""),
    );
  }
}
