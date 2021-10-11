import 'package:exservice/renovation/app.dart';
import 'package:exservice/renovation/bloc/default/application_bloc/application_cubit.dart';
import 'package:exservice/renovation/bloc/view/account_bloc/account_bloc.dart';
import 'package:exservice/renovation/controller/data_store.dart';
import 'package:exservice/renovation/controller/firebase_messaging_handler.dart';
import 'package:exservice/renovation/layout/auth/Intro_layout.dart';
import 'package:exservice/renovation/layout/main_layout.dart';
import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/styles/app_theme.dart';
import 'package:exservice/resources/api/ApiProviderDelegate.dart';
import 'package:exservice/resources/api/FakeApiProvidor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';

Future<void> initialize() async {
  await DataStore.instance.init();
  await FirebaseMessagingHandler.instance.initialize();
  GetIt.I.allowReassignment = true;
  GetIt.I.registerSingleton<ApiProviderDelegate>(FakeApiProvider());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await initialize();
    print('language loaded is : ${DataStore.instance.lang}');
    if (!DataStore.instance.hasUser) {
      print('there is no session');
    } else {
      print('user loaded is : ${DataStore.instance.user.username}');
      print('user session is : ${DataStore.instance.user.apiToken}');
    }
  } finally {
    runApp(
      AppMaterial(),
    );
  }
}

class AppMaterial extends StatefulWidget {
  @override
  _AppMaterialState createState() => _AppMaterialState();
}

class _AppMaterialState extends State<AppMaterial> {
  final _appBloc = ApplicationCubit();
  final _accountBloc = AccountBloc();

  @override
  void initState() {
    FirebaseMessagingHandler.instance.tokenMonitor();
    FirebaseMessagingHandler.instance.messageMonitor();
    super.initState();
  }

  @override
  void dispose() {
    _appBloc.close();
    _accountBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _appBloc),
        BlocProvider.value(value: _accountBloc),
      ],
      child: BlocBuilder<ApplicationCubit, ApplicationState>(
        builder: (context, state) {
          return MaterialApp(
            key: _appBloc.key,
            navigatorKey: Application.instance.globalKey,
            initialRoute: MainLayout.route,
            title: "ExService",
            routes: {
              MainLayout.route: (context) =>
                  DataStore.instance.hasUser ? MainLayout() : IntroLayout(),
            },
            theme: appTheme,
            debugShowCheckedModeBanner: false,
            supportedLocales: [
              const Locale('ar'),
              const Locale('en'),
            ],
            localizationsDelegates: [
              const AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
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
      ),
    );
  }
}
