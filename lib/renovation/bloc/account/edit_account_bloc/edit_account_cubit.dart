import 'package:exservice/models/common/User.dart';
import 'package:exservice/renovation/bloc/view/account_bloc/account_bloc.dart';
import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/resources/api/ApiProviderDelegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'edit_account_factory.dart';
part 'edit_account_state.dart';

class EditAccountCubit extends Cubit<EditAccountState> {
  final EditAccountFactory factory;

  EditAccountCubit(this.factory) : super(EditAccountInitial());

  @override
  Future<Function> close() {
    factory.dispose();
    return super.close();
  }

  Future<void> update() async {
    try {
      emit(EditAccountAwaitState());
      factory.validate();
      if (factory.valid) {
        await factory.update();
        emit(EditAccountCommittedState());
      } else {
        emit(EditAccountInitial());
      }
    } catch (e) {
      emit(EditAccountErrorState("$e"));
    }
  }
}
