import 'package:exservice/bloc/application_bloc/application_cubit.dart';
import 'package:exservice/bloc/auth/login_bloc/login_bloc.dart';
import 'package:exservice/bloc/contact_us_bloc/contact_us_bloc.dart';
import 'package:exservice/bloc/profile_bloc/profile_bloc.dart';
import 'package:exservice/controller/data_store.dart';
import 'package:exservice/layout/account/settings_layout.dart';
import 'package:exservice/layout/app/about_us_layout.dart';
import 'package:exservice/layout/app/contact_us_layout.dart';
import 'package:exservice/layout/app/info_layout.dart';
import 'package:exservice/layout/auth/login_layout.dart';
import 'package:exservice/layout/app/change_language_layout.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/utils/sizer.dart';
import 'package:exservice/widget/application/global_widgets.dart';
import 'package:exservice/widget/bottom_sheets/action_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:faker/faker.dart';

class DrawerLayout extends StatelessWidget {
  final StackLoaderIndicator _loaderIndicator = StackLoaderIndicator();

  DrawerLayout({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _bloc = BlocProvider.of<ProfileBloc>(context);
    var isAuthenticated = _bloc.isAuthenticated;
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLogoutAwaitState) {
          _loaderIndicator.show(context);
        } else if (state is ProfileLogoutAcceptState) {
          Fluttertoast.showToast(
            msg: AppLocalization.of(context).translate("logged_out"),
            toastLength: Toast.LENGTH_LONG,
          );
          BlocProvider.of<ApplicationCubit>(context).restart();
        } else if (state is ProfileLogoutErrorState) {
          _loaderIndicator.dismiss();
          Fluttertoast.showToast(msg: state.error.toString());
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: ListView(
          children: [
            if (!isAuthenticated)
              ListTile(
                leading: Icon(
                  Icons.person_outline,
                  size: Sizer.iconSizeLarge,
                ),
                title: Text(
                  AppLocalization.of(context).translate("guest"),
                ),
                trailing: Text(
                  AppLocalization.of(context).translate("login"),
                  style: Theme.of(context).primaryTextTheme.titleSmall,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => LoginBloc(),
                        child: LoginLayout(),
                      ),
                    ),
                  );
                },
              ),
            // if (isAuthenticated)
            //   BlocBuilder<ProfileBloc, ProfileState>(
            //     buildWhen: (_, current) =>
            //         current is ProfileAcceptState ||
            //         current is ProfileUpdateAcceptState,
            //     builder: (context, state) {
            //       return ListTile(
            //         leading: SvgPicture.asset(
            //           "assets/svg/user.svg",
            //           height: iconSize,
            //           width: iconSize,
            //         ),
            //         title: getUserWidget(context),
            //         trailing: getTrailing(context),
            //         onTap: () {
            //           Navigator.of(context).push(
            //             CupertinoPageRoute(
            //               builder: (context) => const ProfileLayout(),
            //             ),
            //           );
            //         },
            //       );
            //     },
            //   ),
            ListTile(
              leading: Icon(
                Icons.language_outlined,
                size: Sizer.iconSizeLarge,
              ),
              title: Text(
                AppLocalization.of(context).translate("change_language"),
              ),
              trailing: getTrailing(context),
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => ChangeLanguageLayout(),
                ));
              },
            ),
            SwitchListTile(
              secondary: Icon(
                CupertinoIcons.moon,
                size: Sizer.iconSizeLarge,
              ),
              inactiveTrackColor: AppColors.gray,
              title: Text(
                AppLocalization.of(context).translate("dark_mode"),
              ),
              value: DataStore.instance.isDarkModeEnabled,
              onChanged: (bool value) {
                BlocProvider.of<ApplicationCubit>(context).switchTheme();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.insert_drive_file_outlined,
                size: Sizer.iconSizeLarge,
              ),
              title: Text(
                AppLocalization.of(context).translate("about_us"),
              ),
              trailing: getTrailing(context),
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => AboutUsLayout(),
                ));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.email_outlined,
                size: Sizer.iconSizeLarge,
              ),
              title: Text(
                AppLocalization.of(context).translate("contact_us"),
              ),
              trailing: getTrailing(context),
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => ContactUsBloc(),
                    child: ContactUsLayout(),
                  ),
                ));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.error_outline,
                size: Sizer.iconSizeLarge,
              ),
              title: Text(
                AppLocalization.of(context).translate("terms_condition"),
              ),
              trailing: getTrailing(context),
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => InfoLayout(
                    title: AppLocalization.of(context)
                        .translate("terms_condition"),
                    content: faker.lorem.sentences(10).join("\n"),
                  ),
                ));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.lock_outline,
                size: Sizer.iconSizeLarge,
              ),
              title: Text(
                AppLocalization.of(context).translate("privacy_police"),
              ),
              trailing: getTrailing(context),
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => InfoLayout(
                    title:
                        AppLocalization.of(context).translate("privacy_police"),
                    content: faker.lorem.sentences(10).join("\n"),
                  ),
                ));
              },
            ),
            // if (isAuthenticated)//todo
              ListTile(
                leading: Icon(
                  Icons.settings_outlined,
                  size: Sizer.iconSizeLarge,
                ),
                title: Text(
                  AppLocalization.of(context).translate("settings"),
                ),
                trailing: getTrailing(context),
                onTap: () {
                  Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => SettingsLayout(),
                  ));
                },
              ),
            ListTile(
              leading: Icon(
                Icons.share_outlined,
                size: Sizer.iconSizeLarge,
              ),
              title: Text(
                AppLocalization.of(context).translate("share_app"),
              ),
              trailing: getTrailing(context),
              onTap: () {},
            ),
            if (isAuthenticated)
              ListTile(
                leading: Icon(
                  Icons.logout_outlined,
                  size: Sizer.iconSizeLarge,
                ),
                title: Text(
                  AppLocalization.of(context).translate("logout"),
                ),
                onTap: () {
                  ActionBottomSheet.show(
                    context,
                    title: AppLocalization.of(context).translate("logout"),
                    subtitle:
                        AppLocalization.of(context).translate("logout_desc"),
                    confirmText:
                        AppLocalization.of(context).translate("logout"),
                    onTap: () {
                      _bloc.add(ProfileLogoutEvent());
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
