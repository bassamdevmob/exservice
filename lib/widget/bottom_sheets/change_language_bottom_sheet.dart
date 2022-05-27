import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:exservice/bloc/application_bloc/application_cubit.dart';
import 'package:exservice/controller/data_store.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/utils/utils.dart';
import 'package:exservice/widget/application/global_widgets.dart';

class ChangeLanguageBottomSheet extends StatelessWidget {
  final Map<String, String> alternative = {
    "ar": "العربية",
    "en": "English",
  };

  Widget getLanguageButton(BuildContext context, String locale) {
    var mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: mediaQuery.size.width * 0.03,
        vertical: mediaQuery.size.width * 0.01,
      ),
      child: PhysicalModel(
        elevation: 2,
        borderRadius: BorderRadius.circular(Utils.cardBorderRadius(mediaQuery)),
        color: AppColors.white,
        child: ListTile(
          title: Text(alternative[locale] ?? "Unknown"),
          trailing: Icon(
            Icons.circle,
            color: DataStore.instance.lang == locale
                ? AppColors.darkGreen
                : AppColors.grayAccent,
            size: Utils.iconSize(mediaQuery),
          ),
          onTap: () {
            BlocProvider.of<ApplicationCubit>(context).changeLanguage(locale);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Material(
      child: CustomScrollView(
        shrinkWrap: true,
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(height: Utils.verticalSpace(mediaQuery)),
              LineBottomSheetWidget(),
              SizedBox(height: Utils.verticalSpace(mediaQuery)),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: mediaQuery.size.width * 0.05,
                ),
                child: Text(
                  AppLocalization.of(context).translate("choose_language"),
                  style: Theme.of(context).textTheme.headline3,
                ),
              )
            ]),
          ),
          SliverPadding(
            padding: EdgeInsets.all(mediaQuery.size.width * 0.04),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                getLanguageButton(context, "ar"),
                getLanguageButton(context, "en"),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

Future<dynamic> showChangeLanguageBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(35),
    ),
    backgroundColor: Colors.transparent,
    builder: (context) => ChangeLanguageBottomSheet(),
  );
}
