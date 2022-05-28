import 'package:exservice/bloc/application_bloc/application_cubit.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/utils/sizer.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

class AboutUsLayout extends StatelessWidget {
  const AboutUsLayout({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.of(context).translate("about_us")),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          Padding(
            padding: EdgeInsets.all(Sizer.vs1),
            child: Image.asset(
              "assets/images/ic_launcher.png",
              height: Sizer.logoSize,
              width: Sizer.logoSize,
            ),
          ),
          Text(
            ApplicationCubit.info.appName,
            textAlign: TextAlign.center,
            style: Theme.of(context).primaryTextTheme.displayMedium,
          ),
          SizedBox(height: Sizer.vs2),
          Text(
            "${AppLocalization.of(context).translate('version')} ${ApplicationCubit.info.version}",
            textAlign: TextAlign.center,
            style: Theme.of(context).primaryTextTheme.labelMedium,
          ),
          SizedBox(height: Sizer.vs2),
          Text(
            faker.lorem.sentences(6).join("\n"),
            style: Theme.of(context).primaryTextTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
