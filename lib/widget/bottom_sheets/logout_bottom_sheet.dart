import 'package:exservice/bloc/profile_bloc/profile_bloc.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/widget/application/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:exservice/utils/sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogoutBottomSheet extends StatelessWidget {
  const LogoutBottomSheet({Key key}) : super(key: key);

  static Future<T> show<T>(BuildContext context) {
    return showModalBottomSheet<T>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: Sizer.bottomSheetBorderRadius,
      ),
      builder: (context) {
        return LogoutBottomSheet();
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
            AppLocalization.of(context).translate("logout"),
            textAlign: TextAlign.start,
            style: Theme.of(context).primaryTextTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalization.of(context).translate("logout_desc"),
            textAlign: TextAlign.start,
            style: Theme.of(context).primaryTextTheme.labelMedium,
          ),
          SizedBox(height: Sizer.vs1),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: ElevatedButton(
              onPressed: () {
                context.read<ProfileBloc>().add(ProfileLogoutEvent());
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
