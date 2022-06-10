import 'package:exservice/bloc/application_bloc/application_cubit.dart';
import 'package:exservice/bloc/profile_bloc/profile_bloc.dart';
import 'package:exservice/layout/main_layout.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomeLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Spacer(),
            Text(
              sprintf(
                AppLocalization.of(context).translate('welcome'),
                [ApplicationCubit.info.appName],
              ),
              style: Theme.of(context)
                  .primaryTextTheme
                  .displayMedium
                  .copyWith(fontFamily: "Satisfy"),
            ),
            Spacer(),
            Text(
              BlocProvider.of<ProfileBloc>(context).model.username,
              style: Theme.of(context).primaryTextTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text(
                AppLocalization.of(context).translate('next'),
              ),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  CupertinoPageRoute(
                    builder: (context) => MainLayout(),
                    settings: RouteSettings(
                      name: MainLayout.route,
                    )
                  ),
                  (route) => false,
                );
              },
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
