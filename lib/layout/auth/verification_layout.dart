import 'package:exservice/bloc/auth/verification_bloc/verification_bloc.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VerificationLayout extends StatefulWidget {
  @override
  _VerificationLayoutState createState() => _VerificationLayoutState();
}

class _VerificationLayoutState extends State<VerificationLayout> {
  VerificationBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<VerificationBloc>(context);
    super.initState();
  }

  void _verify() {
    _bloc.add(VerificationCommitEvent());
  }

  void _resend() {
    _bloc.add(VerificationResendPinEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VerificationBloc, VerificationState>(
      listenWhen: (_, current) =>
          current is VerificationWaitBeforeResendState ||
          current is VerificationErrorState ||
          current is VerificationCommittedState ||
          current is VerificationCommittedResendState,
      listener: (context, state) {
        if (state is VerificationWaitBeforeResendState) {
          Fluttertoast.showToast(
            msg: AppLocalization.of(context).trans("wait") +
                " ${state.seconds} " +
                AppLocalization.of(context).trans("wait_before_try"),
          );
        } else if (state is VerificationErrorState) {
          Fluttertoast.showToast(msg: state.message);
        } else if (state is VerificationCommittedResendState) {
          Fluttertoast.showToast(
            msg: AppLocalization.of(context).trans("sent_successfully"),
          );
        } else if (state is VerificationCommittedState) {
          _bloc.factory.afterVerified(context);
        }
      },
      child: Scaffold(
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Center(
                      child: Text(
                        AppLocalization.of(context)
                            .trans('enter_confirmation_code'),
                        style: AppTextStyle.xLargeBlackBold,
                      ),
                    ),
                    SizedBox(height: 20),
                    getPinField(),
                    SizedBox(height: 20),
                    getSubmitButton(),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: getResendButton(),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget getPinField() {
    return BlocBuilder<VerificationBloc, VerificationState>(
      buildWhen: (_, current) => current is VerificationValidationState,
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: TextField(
            maxLength: 6,
            controller: _bloc.pinController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: AppLocalization.of(context).trans("confirmation_code"),
              labelStyle: AppTextStyle.largeBlue,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              errorText: _bloc.pinErrorMessage,
            ),
          ),
        );
      },
    );
  }

  Widget getSubmitButton() {
    return BlocBuilder<VerificationBloc, VerificationState>(
      buildWhen: (_, current) =>
          current is VerificationErrorState ||
          current is VerificationCommittedState ||
          current is VerificationAwaitState,
      builder: (context, state) {
        return ElevatedButton(
          child: state is VerificationAwaitState
              ? CupertinoActivityIndicator()
              : Text(
                  AppLocalization.of(context).trans('next'),
                  style: AppTextStyle.mediumWhite,
                ),
          onPressed: state is VerificationAwaitState ? null : _verify,
        );
      },
    );
  }

  Widget getResendButton() {
    return BlocBuilder<VerificationBloc, VerificationState>(
      buildWhen: (_, current) =>
          current is VerificationCommittedResendState ||
          current is VerificationErrorState ||
          current is VerificationAwaitResendState,
      builder: (context, state) {
        print(state.runtimeType);
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Text(
            AppLocalization.of(context).trans('resend_code'),
            style: (state is VerificationAwaitResendState
                    ? AppTextStyle.smallGrayBold
                    : AppTextStyle.smallBlueBold)
                .copyWith(decoration: TextDecoration.underline),
          ),
          onTap: state is VerificationAwaitResendState ? null : _resend,
        );
      },
    );
  }
}
