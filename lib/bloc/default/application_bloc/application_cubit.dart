import 'package:bloc/bloc.dart';
import 'package:exservice/controller/data_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'application_state.dart';

class ApplicationCubit extends Cubit<ApplicationState> {
  static Key key = UniqueKey();
  static final navigatorKey = GlobalKey<NavigatorState>();
  static PackageInfo info;

  static Future<void> init() async {
    info = await PackageInfo.fromPlatform();
  }

  ApplicationCubit() : super(ApplicationInitial());

  void restart() {
    key = UniqueKey();
    emit(ApplicationInitial());
  }

  void update() {
    emit(ApplicationInitial());
  }

  Future<void> changeLanguage(String code) async {
    await DataStore.instance.setLang(code);
    emit(ApplicationInitial());
  }

  Future<void> switchTheme() async {
    try {
      await DataStore.instance.switchTheme();
    } finally {
      emit(ApplicationInitial());
    }
  }
}
