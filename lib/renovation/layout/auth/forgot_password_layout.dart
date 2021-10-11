import 'package:exservice/renovation/bloc/auth/forgot_password_bloc/forgot_password_bloc.dart';
import 'package:exservice/renovation/bloc/auth/verification_bloc/verification_bloc.dart';
import 'package:exservice/renovation/layout/auth/verification_layout.dart';
import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
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

  void _sendCode() async {
    _bloc.add(ForgotPasswordCommitEvent());
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
                  context,
                  VerificationOnChangePasswordFactory(state.session),
                ),
                child: VerificationLayout(),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Center(
                          child: Text(
                            AppLocalization.of(context).trans('forget'),
                            style: AppTextStyle.xxLargeBlack,
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            AppLocalization.of(context).trans('enter_account'),
                            style: AppTextStyle.mediumGray,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 20),
                        getAccountField(),
                        SizedBox(height: 20),
                        getSubmitButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
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
              labelText: AppLocalization.of(context).trans("account"),
              labelStyle: AppTextStyle.largeBlue,
              floatingLabelBehavior: FloatingLabelBehavior.always,
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
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: state is ForgotPasswordAwaitState
                ? CupertinoActivityIndicator()
                : Text(
                    AppLocalization.of(context).trans('send_code'),
                    style: AppTextStyle.mediumWhite,
                  ),
          ),
          onPressed: state is ForgotPasswordAwaitState ? null : _sendCode,
        );
      },
    );
  }
}
