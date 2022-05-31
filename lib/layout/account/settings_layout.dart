import 'package:exservice/bloc/account/change_password_bloc/change_password_bloc.dart';
import 'package:exservice/bloc/account/manage_email_address_bloc/manage_email_address_bloc.dart';
import 'package:exservice/bloc/account/manage_phone_number_bloc/manage_phone_number_bloc.dart';
import 'package:exservice/bloc/profile_bloc/profile_bloc.dart';
import 'package:exservice/layout/account/edit/change_password_layout.dart';
import 'package:exservice/layout/account/edit/manage_email_address_layout.dart';
import 'package:exservice/layout/account/edit/manage_phone_number_layout.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/utils/sizer.dart';
import 'package:exservice/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_number/phone_number.dart';

class SettingsLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = BlocProvider.of<ProfileBloc>(context).model;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalization.of(context).translate("settings"),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Sizer.hs3,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Sizer.vs2),
                Text(
                  AppLocalization.of(context)
                      .translate("personal_information_settings"),
                  style: Theme.of(context)
                      .primaryTextTheme
                      .bodyLarge
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                ListTile(
                  leading: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.email,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  title: Text(
                    user.email,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .bodyMedium
                        .copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    AppLocalization.of(context).translate("email"),
                    style: Theme.of(context).primaryTextTheme.labelMedium,
                  ),
                  contentPadding: EdgeInsets.zero,
                  onTap: () {
                    Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => ManageEmailAddressBloc(),
                        child: ManageEmailAddressLayout(),
                      ),
                    ));
                  },
                ),
                Divider(color: AppColors.deepGray, indent: 50),
                ListTile(
                  leading: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.phone,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  title: FutureBuilder<PhoneNumber>(
                    future: Utils.formatPhoneNumber(user.phoneNumber),
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.hasData
                            ? snapshot.data.international
                            : user.phoneNumber,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .bodyMedium
                            .copyWith(fontWeight: FontWeight.w600),
                      );
                    },
                  ),
                  subtitle: Text(
                    AppLocalization.of(context).translate("mobile"),
                    style: Theme.of(context)
                        .primaryTextTheme
                        .labelMedium,
                  ),
                  contentPadding: EdgeInsets.zero,
                  onTap: () {
                    Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => ManagePhoneNumberBloc(context),
                        child: ManagePhoneNumberLayout(),
                      ),
                    ));
                  },
                ),
              ],
            ),
          ),
          Divider(color: AppColors.deepGray),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Sizer.hs3,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Sizer.vs2),
                Text(
                  AppLocalization.of(context)
                      .translate("password_security"),
                  style: Theme.of(context)
                      .primaryTextTheme
                      .bodyLarge
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                ListTile(
                  leading: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.key,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  title: Text(
                    AppLocalization.of(context).translate("password"),
                    style: Theme.of(context)
                        .primaryTextTheme
                        .bodyMedium
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    AppLocalization.of(context).translate("change_password"),
                    style: Theme.of(context)
                        .primaryTextTheme
                        .labelMedium,
                  ),
                  contentPadding: EdgeInsets.zero,
                  onTap: () {
                    Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => ChangePasswordBloc(),
                        child: ChangePasswordLayout(),
                      ),
                    ));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}