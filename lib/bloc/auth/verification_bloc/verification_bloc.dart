import 'dart:async';

import 'package:exservice/bloc/auth/login_bloc/login_bloc.dart';
import 'package:exservice/bloc/auth/reset_password_bloc/reset_password_bloc.dart';
import 'package:exservice/controller/data_store.dart';
import 'package:exservice/layout/auth/login_layout.dart';
import 'package:exservice/layout/auth/reset_password_layout.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/resources/repository/auth_repository.dart';
import 'package:exservice/utils/localized.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

part 'verification_event.dart';

part 'verification_factory.dart';

part 'verification_state.dart';

class VerificationBloc extends Bloc<VerificationEvent, VerificationState> {
  final pinController = TextEditingController();
  final VerificationFactory factory;

  bool obscurePassword = true;

  Localized pinErrorMessage;

  Timer _timer;
  int _multi = 1;
  int _count = 1;

  bool get valid => pinErrorMessage == null;

  void _validate() {
    String pin = pinController.text.trim();

    pinErrorMessage = pin.length != 6 ? Localized("invalid") : null;
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    pinController.dispose();
    return super.close();
  }

  VerificationBloc(this.factory) : super(VerificationInitial()) {
    on((event, emit) async {
      if (event is VerificationResendPinEvent) {
        try {
          if (_timer != null && _timer.isActive) {
            emit(VerificationWaitBeforeResendState(_count));
            return;
          }
          emit(VerificationAwaitResendState());
          _count = _multi * 20;
          _multi *= 2;
          _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
            if (_count < 1) {
              timer.cancel();
            } else {
              _count -= 1;
            }
          });
          await factory.onResend();
          emit(VerificationCommittedResendState());
        } catch (e) {
          emit(VerificationErrorState("$e"));
        }
      } else if (event is VerificationValidateEvent) {
        _validate();
        emit(VerificationValidationState());
      } else if (event is VerificationCommitEvent) {
        _validate();
        emit(VerificationValidationState());
        if (valid) {
          emit(VerificationAwaitState());
          try {
            var code = pinController.text.trim();
            await factory.onVerify(code);
            emit(VerificationCommittedState());
          } catch (e) {
            emit(VerificationErrorState("$e"));
          }
        }
      }
    });
  }
}
