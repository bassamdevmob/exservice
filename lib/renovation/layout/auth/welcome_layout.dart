import 'package:exservice/renovation/controller/data_store.dart';
import 'package:exservice/renovation/layout/main_layout.dart';
import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:flutter/material.dart';

class WelcomeLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Center(
                      child: Text(
                        AppLocalization.of(context).trans('welcome'),
                        style: AppTextStyle.largeBlackBold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        DataStore.instance.user.username,
                        style: AppTextStyle.largeBlackBold,
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      child: Text(
                        AppLocalization.of(context).trans('next'),
                        style: AppTextStyle.mediumWhite,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          MainLayout.route,
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
