import 'package:exservice/bloc/profile_bloc/profile_bloc.dart';
import 'package:exservice/layout/main_layout.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                        AppLocalization.of(context).translate('welcome'),
                        style: AppTextStyle.largeBlackBold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        BlocProvider.of<ProfileBloc>(context).model.username,
                        style: AppTextStyle.largeBlackBold,
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      child: Text(
                        AppLocalization.of(context).translate('next'),
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
