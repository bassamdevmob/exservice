import 'package:exservice/bloc/default/application_bloc/application_cubit.dart';
import 'package:exservice/controller/data_store.dart';
import 'package:exservice/layout/auth/Intro_layout.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:exservice/utils/utils.dart';
import 'package:exservice/widget/bottom_sheets/change_language_bottom_sheet.dart';
import 'package:exservice/widget/button/action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrawerLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        iconTheme: IconThemeData(color: AppColors.blue),
        centerTitle: true,
        title: Text(
          AppLocalization.of(context).trans('app_name'),
          style: AppTextStyle.largeBlack,
        ),
      ),
      backgroundColor: AppColors.white,
      body: LayoutBuilder(
        builder: (context, constraint) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: Utils.verticalSpace(mediaQuery) * 2,
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      // ActionButton(
                      //   AppLocalization.of(context).trans("my_profile"),
                      //   AppLocalization.of(context).trans("my_profile_title"),
                      //   () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) {
                      //           return BlocProvider<ProfileBloc>(
                      //             create: (context) => ProfileBloc(),
                      //             child: ProfileUi(),
                      //           );
                      //         },
                      //       ),
                      //     );
                      //   },
                      // ),
                      ActionButton(
                        AppLocalization.of(context).trans("about_us"),
                        AppLocalization.of(context).trans("about_us_sub_title"),
                        () {},
                      ),
                      ActionButton(
                        AppLocalization.of(context).trans("language"),
                        AppLocalization.of(context).trans("change_language"),
                        () {
                          showChangeLanguageBottomSheet(context);
                        },
                      ),
                      if (DataStore.instance.hasUser)
                        ActionButton(
                          AppLocalization.of(context).trans("logout"),
                          AppLocalization.of(context).trans("logout_title"),
                          () {
                            DataStore.instance.deleteUser();
                            BlocProvider.of<ApplicationCubit>(context).update();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => IntroLayout(),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
