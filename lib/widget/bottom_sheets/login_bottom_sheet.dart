import 'package:exservice/bloc/auth/login_bloc/login_bloc.dart';
import 'package:exservice/layout/auth/login_layout.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/widget/application/global_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:exservice/utils/sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBottomSheet extends StatelessWidget {
  const LoginBottomSheet({Key key}) : super(key: key);

  static Future<T> show<T>(BuildContext context) {
    return showModalBottomSheet<T>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: Sizer.bottomSheetBorderRadius,
      ),
      builder: (context) {
        return LoginBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Sizer.bottomSheetPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(child: BottomSheetStroke()),
          SizedBox(height: Sizer.vs2),
          Text(
            AppLocalization.of(context).translate("need_login"),
            textAlign: TextAlign.start,
            style: Theme.of(context).primaryTextTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalization.of(context).translate("need_login_desc"),
            textAlign: TextAlign.start,
            style: Theme.of(context).primaryTextTheme.labelMedium,
          ),
          SizedBox(height: Sizer.vs1),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => LoginBloc(),
                      child: LoginLayout(),
                    ),
                  ),
                );
              },
              child: Text(
                AppLocalization.of(context).translate("next"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
