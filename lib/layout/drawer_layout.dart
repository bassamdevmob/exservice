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
import 'package:exservice/layout/upload/upload_manager_layout.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/utils/sizer.dart';
import 'package:exservice/widget/application/global_widgets.dart';
import 'package:exservice/widget/bottom_sheets/logout_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DrawerLayout extends StatelessWidget {
  final StackLoaderIndicator _loaderIndicator = StackLoaderIndicator();

  DrawerLayout({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            if (!context.read<ProfileBloc>().isAuthenticated)
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
                    content: """Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32. The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.""",
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
                    content: """Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32. The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.""",
                  ),
                ));
              },
            ),
            if (context.read<ProfileBloc>().isAuthenticated)
              ListTile(
                leading: Icon(
                  Icons.upload_outlined,
                  size: Sizer.iconSizeLarge,
                ),
                title: Text(
                  AppLocalization.of(context).translate("uploads"),
                ),
                trailing: getTrailing(context),
                onTap: () {
                  Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => UploadManagerLayout(),
                  ));
                },
              ),
            if (context.read<ProfileBloc>().isAuthenticated)
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
                    settings: RouteSettings(
                      name: SettingsLayout.route,
                    ),
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
            if (context.read<ProfileBloc>().isAuthenticated)
              ListTile(
                leading: Icon(
                  Icons.logout_outlined,
                  size: Sizer.iconSizeLarge,
                ),
                title: Text(
                  AppLocalization.of(context).translate("logout"),
                ),
                onTap: () {
                  LogoutBottomSheet.show(context);
                },
              ),
          ],
        ),
      ),
    );
  }
}
