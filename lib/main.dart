import 'dart:developer';

import 'package:exservice/bloc/application_bloc/application_cubit.dart';
import 'package:exservice/bloc/profile_bloc/profile_bloc.dart';
import 'package:exservice/bloc/upload_manger_bloc/upload_manager_bloc.dart';
import 'package:exservice/controller/data_store.dart';
import 'package:exservice/layout/main_layout.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/resources/repository/ad_repository.dart';
import 'package:exservice/resources/repository/auth_repository.dart';
import 'package:exservice/resources/repository/config_repository.dart';
import 'package:exservice/resources/repository/user_repository.dart';
import 'package:exservice/styles/themes/dark_theme.dart';
import 'package:exservice/styles/themes/light_theme.dart';
import 'package:exservice/utils/global.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  try {
    await Future.wait([
      Firebase.initializeApp(),
      ApplicationCubit.init(),
      DataStore.instance.init(),
    ]);
  } finally {
    GetIt.I.allowReassignment = true;
    GetIt.I.registerSingleton<AdRepository>(AdRepository());
    GetIt.I.registerSingleton<AuthRepository>(AuthRepository());
    GetIt.I.registerSingleton<UserRepository>(UserRepository());
    GetIt.I.registerSingleton<ConfigRepository>(ConfigRepository());
    FlutterNativeSplash.remove();
    log('language loaded is : ${DataStore.instance.lang}');
    if (DataStore.instance.hasToken) {
      log('user token is : ${DataStore.instance.token}');
    } else {
      log('there is no user');
    }
    runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => UploadManagerBloc()),
          BlocProvider(create: (context) => ApplicationCubit()),
          BlocProvider(create: (context) => ProfileBloc()),
        ],
        child: const AppMaterial(),
      ),
    );
  }
}

class AppMaterial extends StatelessWidget {
  const AppMaterial({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return BlocBuilder<ApplicationCubit, ApplicationState>(
      builder: (context, state) {
        return MaterialApp(
          key: ApplicationCubit.key,
          navigatorKey: navigatorKey,
          title: ApplicationCubit.info.appName,
          initialRoute: MainLayout.route,
          routes: {
            MainLayout.route: (context) => MainLayout(),
          },
          themeMode: DataStore.instance.isDarkModeEnabled
              ? ThemeMode.dark
              : ThemeMode.light,
          theme: lightTheme,
          darkTheme: darkTheme,
          debugShowCheckedModeBanner: false,
          supportedLocales: [
            const Locale('ar'),
            const Locale('en'),
          ],
          localizationsDelegates: [
            const AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: Locale(DataStore.instance.lang),
          localeResolutionCallback: (locale, locales) {
            for (Locale supportedLocale in locales) {
              if (supportedLocale.languageCode == locale.languageCode) {
                return supportedLocale;
              }
            }
            return locales.first;
          },
        );
      },
    );
  }
}
