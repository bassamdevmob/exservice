import 'package:exservice/bloc/application_bloc/application_cubit.dart';
import 'package:exservice/controller/data_store.dart';
import 'package:exservice/layout/main_layout.dart';
import 'package:exservice/utils/sizer.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

class WelcomeLayout extends StatelessWidget {
  static const route = '/wlc';

  const WelcomeLayout({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          decoration: PageDecoration(
            imagePadding: EdgeInsets.only(top: Sizer.iconSizeLarge)
          ),
          useScrollView: false,
          titleWidget: Text(
            "Welcome",
            style: Theme.of(context).textTheme.displayLarge,
          ),
          bodyWidget: Text(
            "We are glad to have you join us.",
            style: Theme.of(context).primaryTextTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          image: Lottie.asset(
            "assets/json/welcome.json",
            width: Sizer.screenSize.width,
          ),
        ),
        PageViewModel(
          decoration: PageDecoration(
              imagePadding: EdgeInsets.only(top: Sizer.iconSizeLarge)
          ),
          titleWidget: Text(
            "Demo",
            style: Theme.of(context).textTheme.displayLarge,
          ),
          bodyWidget: Text(
            "Before you start, you have to know that this is a dummy version of the application made for reviewers",
            style: Theme.of(context).primaryTextTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          image: Lottie.asset(
            "assets/json/mobile-development.json",
            width: Sizer.screenSize.width,
          ),
        ),
        PageViewModel(
          decoration: PageDecoration(
              imagePadding: EdgeInsets.only(top: Sizer.iconSizeLarge)
          ),
          titleWidget: Text(
            ApplicationCubit.info.appName,
            style: Theme.of(context).textTheme.displayLarge,
          ),
          bodyWidget: Text(
            "Easy to share your property information with ExService community. Many other features waiting for you",
            style: Theme.of(context).primaryTextTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          image: Lottie.asset(
            "assets/json/blue-house.json",
            width: Sizer.screenSize.width,
          ),
        ),
      ],
      showDoneButton: true,
      showNextButton: true,
      next: const Text("Next"),
      done: const Text("Done"),
      onDone: () {
        DataStore.instance.introEnds();
        Navigator.of(context).pushReplacementNamed(MainLayout.route);
      },
    );
  }
}
