import 'package:exservice/bloc/auth/forgot_password_bloc/forgot_password_bloc.dart';
import 'package:exservice/bloc/auth/verification_bloc/verification_bloc.dart';
import 'package:exservice/layout/auth/verification_layout.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:exservice/widget/application/global_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordLayout extends StatefulWidget {
  @override
  _ForgotPasswordLayoutState createState() => _ForgotPasswordLayoutState();
}

class _ForgotPasswordLayoutState extends State<ForgotPasswordLayout> {
  ForgotPasswordBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<ForgotPasswordBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listenWhen: (_, current) =>
          current is ForgotPasswordErrorState ||
          current is ForgotPasswordCommittedState,
      listener: (context, state) {
        if (state is ForgotPasswordErrorState) {
          Fluttertoast.showToast(msg: state.message);
        } else if (state is ForgotPasswordCommittedState) {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => VerificationBloc(
                  VerificationOnResetPasswordFactory(state.session),
                ),
                child: VerificationLayout(),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalization.of(context).translate("forget_password")),
        ),
        body: ExpandedSingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  AppLocalization.of(context).translate('enter_account'),
                  style: Theme.of(context).primaryTextTheme.bodySmall,
                ),
                SizedBox(height: 20),
                getAccountField(),
                SizedBox(height: 20),
                getSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getAccountField() {
    return BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
      buildWhen: (_, current) => current is ForgotPasswordValidationState,
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: TextField(
            controller: _bloc.accountController,
            decoration: InputDecoration(
              hintText: AppLocalization.of(context).translate("email_phone_number"),
              errorText: _bloc.accountErrorMessage,
            ),
          ),
        );
      },
    );
  }

  Widget getSubmitButton() {
    return BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
      buildWhen: (_, current) =>
          current is ForgotPasswordErrorState ||
          current is ForgotPasswordCommittedState ||
          current is ForgotPasswordAwaitState,
      builder: (context, state) {
        return ElevatedButton(
          child: state is ForgotPasswordAwaitState
              ? CupertinoActivityIndicator()
              : Text(
                  AppLocalization.of(context).translate('send'),
                  style: AppTextStyle.mediumWhite,
                ),
          onPressed: state is ForgotPasswordAwaitState
              ? null
              : () {
                  _bloc.add(ForgotPasswordCommitEvent());
                },
        );
      },
    );
  }
}
