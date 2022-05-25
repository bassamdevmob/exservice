import 'package:bloc/bloc.dart';
import 'package:exservice/controller/data_store.dart';
import 'package:flutter/cupertino.dart';

part 'application_state.dart';

class ApplicationCubit extends Cubit<ApplicationState> {
  Key key = UniqueKey();

  ApplicationCubit() : super(ApplicationInitial());

  void refresh() {
    key = UniqueKey();
    emit(ApplicationInitial());
  }

  void update() {
    emit(ApplicationInitial());
  }

  void changeLanguage(String code) {
    DataStore.instance.lang = code;
    emit(ApplicationInitial());
  }
}
