import 'package:exservice/bloc/application_bloc/application_cubit.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/utils/sizer.dart';
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
            """Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32. The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.""",
            style: Theme.of(context).primaryTextTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
