import 'package:exservice/bloc/auth/verification_bloc/verification_bloc.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:exservice/utils/sizer.dart';
import 'package:exservice/utils/utils.dart';
import 'package:exservice/widget/application/global_widgets.dart';
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
          current is VerificationAcceptState ||
          current is VerificationResendAcceptState,
      listener: (context, state) {
        if (state is VerificationWaitBeforeResendState) {
          Fluttertoast.showToast(
            msg:
                "${state.seconds} sec ${AppLocalization.of(context).translate("for_try_again")}",
          );
        } else if (state is VerificationErrorState) {
          Fluttertoast.showToast(
            msg: Utils.resolveErrorMessage(state.error),
            toastLength: Toast.LENGTH_LONG,
          );
        } else if (state is VerificationResendAcceptState) {
          Fluttertoast.showToast(
            msg: AppLocalization.of(context).translate("code_sent"),
          );
        } else if (state is VerificationAcceptState) {
          _bloc.factory.afterVerified(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: ExpandedSingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Sizer.hs3,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: Text(
                    AppLocalization.of(context)
                        .translate('enter_confirmation_code'),
                    style: Theme.of(context).primaryTextTheme.labelLarge,
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
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText:
                  AppLocalization.of(context).translate("confirmation_code"),
              errorText: _bloc.pinErrorMessage?.toString(),
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
          current is VerificationAcceptState ||
          current is VerificationAwaitState,
      builder: (context, state) {
        return ElevatedButton(
          child: state is VerificationAwaitState
              ? CupertinoActivityIndicator()
              : Text(
                  AppLocalization.of(context).translate('next'),
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
          current is VerificationResendAcceptState ||
          current is VerificationErrorState ||
          current is VerificationResendAwaitState,
      builder: (context, state) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Text(
            AppLocalization.of(context).translate('resend_code'),
            style: (state is VerificationResendAwaitState
                    ? AppTextStyle.smallGray
                    : AppTextStyle.smallBlue)
                .copyWith(decoration: TextDecoration.underline),
          ),
          onTap: state is VerificationResendAwaitState ? null : _resend,
        );
      },
    );
  }
}
