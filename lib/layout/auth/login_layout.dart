import 'package:exservice/bloc/auth/forgot_password_bloc/forgot_password_bloc.dart';
import 'package:exservice/bloc/auth/login_bloc/login_bloc.dart';
import 'package:exservice/layout/auth/Intro_layout.dart';
import 'package:exservice/layout/auth/forgot_password_layout.dart';
import 'package:exservice/layout/auth/welcome_layout.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:exservice/utils/utils.dart';
import 'package:exservice/widget/application/global_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginLayout extends StatefulWidget {
  static const route = "/login";

  @override
  _LoginLayoutState createState() => _LoginLayoutState();
}

class _LoginLayoutState extends State<LoginLayout> {
  LoginBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<LoginBloc>(context);
    super.initState();
  }

  _navigateToForgotPassword() {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => ForgotPasswordBloc(context),
          child: ForgotPasswordLayout(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (_, current) =>
          current is LoginAcceptState || current is LoginErrorState,
      listener: (context, state) {
        if (state is LoginAcceptState) {
          Navigator.of(context).pushReplacement(
            CupertinoPageRoute(
              builder: (context) => WelcomeLayout(),
            ),
          );
        } else if (state is LoginErrorState) {
          Fluttertoast.showToast(msg: state.error.toString());
        }
      },
      child: Scaffold(
        body: ExpandedSingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(),
              Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Center(
                      child: Text(
                        AppLocalization.of(context).translate('app_name'),
                        style: AppTextStyle.xxxxLargeBlackSatisfy,
                      ),
                    ),
                    SizedBox(height: 20),
                    getAccountField(),
                    SizedBox(height: 20),
                    getPasswordField(),
                    SizedBox(height: 20),
                    getSubmitButton(),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: InkWell(
                      onTap: _navigateToForgotPassword,
                      child: Text(
                        AppLocalization.of(context).translate('forget'),
                        style: AppTextStyle.smallBlackBold,
                      ),
                    ),
                  ),
                  Divider(height: 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 23,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          AppLocalization.of(context).translate('no_account'),
                          style: AppTextStyle.smallGray,
                        ),
                        SizedBox(width: 5),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => IntroLayout(),
                              ),
                            );
                          },
                          child: Text(
                            '${AppLocalization.of(context).translate('register')}.',
                            style: AppTextStyle.smallBlackBold,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getSubmitButton() {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (_, current) =>
          current is LoginAwaitState ||
          current is LoginAcceptState ||
          current is LoginErrorState,
      builder: (context, state) {
        return ElevatedButton(
          child: state is LoginAwaitState
              ? CupertinoActivityIndicator()
              : Text(
                  AppLocalization.of(context).translate('login'),
                  style: AppTextStyle.mediumWhite,
                ),
          onPressed: state is LoginAwaitState
              ? null
              : () {
                  _bloc.add(LoginCommitEvent());
                },
        );
      },
    );
  }

  Widget getAccountField() {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (_, current) => current is LoginValidationState,
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: TextField(
            controller: _bloc.accountController,
            decoration: InputDecoration(
              labelText: AppLocalization.of(context).translate("account"),
              labelStyle: AppTextStyle.largeBlue,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              errorText: _bloc.accountErrorMessage?.toString(),
            ),
          ),
        );
      },
    );
  }

  Widget getPasswordField() {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (_, current) =>
          current is LoginSecurePasswordState ||
          current is LoginValidationState,
      builder: (context, state) {
        return TextField(
          textDirection: TextDirection.ltr,
          controller: _bloc.passwordController,
          keyboardType: TextInputType.visiblePassword,
          obscureText: _bloc.obscurePassword,
          decoration: InputDecoration(
            labelText: AppLocalization.of(context).translate("password"),
            labelStyle: AppTextStyle.largeBlue,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: IconButton(
              onPressed: () {
                _bloc.add(LoginSecurePasswordEvent());
              },
              icon: Icon(
                _bloc.obscurePassword ? Icons.visibility : Icons.visibility_off,
                color: AppColors.gray,
                size: Utils.iconSize(MediaQuery.of(context)),
              ),
            ),
            errorText: _bloc.passwordErrorMessage?.toString(),
          ),
        );
      },
    );
  }
}
