import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:exservice/renovation/bloc/auth/reset_password_bloc/reset_password_bloc.dart';
import 'package:exservice/renovation/controller/data_store.dart';
import 'package:exservice/renovation/layout/auth/reset_password_layout.dart';
import 'package:exservice/renovation/layout/auth/welcome_layout.dart';
import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/resources/api/ApiProviderDelegate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'verification_event.dart';
part 'verification_factory.dart';
part 'verification_state.dart';

class VerificationBloc extends Bloc<VerificationEvent, VerificationState> {
  final pinController = TextEditingController();
  final VerificationFactory factory;
  final BuildContext context;
  final String account;

  bool obscurePassword = true;

  String pinErrorMessage;

  Timer _timer;
  int _multi = 1;
  int _count = 1;

  VerificationBloc(this.context, this.account, this.factory)
      : super(VerificationInitial());

  bool get valid => pinErrorMessage == null;

  void _validate() {
    String pin = pinController.text.trim();

    pinErrorMessage =
        pin.length != 6 ? AppLocalization.of(context).trans("invalid") : null;
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    pinController.dispose();
    return super.close();
  }

  @override
  Stream<VerificationState> mapEventToState(
    VerificationEvent event,
  ) async* {
    if (event is VerificationResendPinEvent) {
      try {
        if (_timer != null && _timer.isActive) {
          yield VerificationWaitBeforeResendState(_count);
          return;
        }
        yield VerificationAwaitResendState();
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
        yield VerificationCommittedResendState();
      } catch (e) {
        yield VerificationErrorState("$e");
      }
    } else if (event is VerificationValidateEvent) {
      _validate();
      yield VerificationValidationState();
    } else if (event is VerificationCommitEvent) {
      _validate();
      yield VerificationValidationState();
      if (valid) {
        yield VerificationAwaitState();
        try {
          var code = pinController.text.trim();
          await factory.onVerify(code);
          yield VerificationCommittedState();
        } catch (e) {
          yield VerificationErrorState("$e");
        }
      }
    }
  }
}
