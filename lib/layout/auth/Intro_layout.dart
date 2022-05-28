import 'package:exservice/bloc/auth/login_bloc/login_bloc.dart';
import 'package:exservice/bloc/auth/register_bloc/register_bloc.dart';
import 'package:exservice/layout/auth/login_layout.dart';
import 'package:exservice/layout/auth/register_layout.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:exservice/utils/sizer.dart';
import 'package:exservice/widget/application/global_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IntroLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ExpandedSingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(),
            Text(
              AppLocalization.of(context).translate('app_name'),
              style: AppTextStyle.xxxxLargeBlackSatisfy,
            ),
            ElevatedButton(
              child: Text(
                AppLocalization.of(context)
                    .translate('register_email _or_phone_number'),
                style: AppTextStyle.mediumWhite,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => RegisterBloc(),
                      child: RegisterLayout(),
                    ),
                  ),
                );
              },
            ),
            Column(
              children: [
                Divider(height: 2),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: Sizer.vs1,
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => LoginBloc(),
                            child: LoginLayout(),
                          ),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          AppLocalization.of(context).translate('had_account'),
                          style: AppTextStyle.smallGray,
                        ),
                        SizedBox(width: 5),
                        Text(
                          '${AppLocalization.of(context).translate('login')}.',
                          style: AppTextStyle.smallBlackBold,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
