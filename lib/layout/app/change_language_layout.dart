import 'package:exservice/bloc/application_bloc/application_cubit.dart';
import 'package:exservice/controller/data_store.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/utils/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangeLanguageLayout extends StatefulWidget {
  const ChangeLanguageLayout({Key key}) : super(key: key);

  @override
  State<ChangeLanguageLayout> createState() => _ChangeLanguageLayoutState();
}

class _ChangeLanguageLayoutState extends State<ChangeLanguageLayout> {
  String value = DataStore.instance.lang;

  final Map<String, String> alternative = {
    "ar": "العربية",
    "en": "English",
  };

  void apply(String locale) {
    setState(() {
      value = locale;
    });
  }

  Widget getLanguageButton(String locale) {
    return ListTile(
      leading: Icon(
        Icons.language_outlined,
        size: Sizer.iconSizeMedium,
      ),
      title: Text(
        alternative[locale],
      ),
      trailing: Radio<String>(
        value: value,
        groupValue: locale,
        onChanged: (_) => apply(locale),
      ),
      onTap: () => apply(locale),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalization.of(context).translate("change_language"),
        ),
      ),
      body: Column(
        children: [
          getLanguageButton("ar"),
          getLanguageButton("en"),
          const Spacer(),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: Sizer.vs1,
                horizontal: Sizer.hs3,
              ),
              child: ElevatedButton(
                onPressed: () {
                  BlocProvider.of<ApplicationCubit>(context)
                      .changeLanguage(value);
                },
                child: Text(
                  AppLocalization.of(context).translate("save"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
