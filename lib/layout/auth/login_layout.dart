import 'package:exservice/bloc/application_bloc/application_cubit.dart';
import 'package:exservice/bloc/auth/forgot_password_bloc/forgot_password_bloc.dart';
import 'package:exservice/bloc/auth/login_bloc/login_bloc.dart';
import 'package:exservice/bloc/profile_bloc/profile_bloc.dart';
import 'package:exservice/controller/data_store.dart';
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
    _bloc = context.read<LoginBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (_, current) =>
          current is LoginAcceptState || current is LoginErrorState,
      listener: (context, state) {
        if (state is LoginAcceptState) {
          DataStore.instance.setToken(state.model.token);
          context.read<ProfileBloc>().model = state.model.user;
          Navigator.of(context).pushReplacement(
            CupertinoPageRoute(
              builder: (context) => WelcomeLayout(),
            ),
          );
        } else if (state is LoginErrorState) {
          Fluttertoast.showToast(msg: Utils.resolveErrorMessage(state.error));
        }
      },
      child: Scaffold(
        body: ExpandedSingleChildScrollView(
          child: Column(
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
                        ApplicationCubit.info.appName,
                        style: Theme.of(context).textTheme.displayLarge,
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
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => ForgotPasswordBloc(context),
                            child: ForgotPasswordLayout(),
                          ),
                        ),
                      );
                    },
                    child: Text(
                      AppLocalization.of(context).translate('forget_password'),
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
                          style: Theme.of(context).primaryTextTheme.labelMedium,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              CupertinoPageRoute(
                                builder: (context) => IntroLayout(),
                              ),
                            );
                          },
                          child: Text(
                            '${AppLocalization.of(context).translate('register')}.',
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
            controller: _bloc.usernameController,
            decoration: InputDecoration(
              hintText:
                  AppLocalization.of(context).translate("username"),
              errorText: _bloc.usernameErrorMessage?.toString(),
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
            hintText: AppLocalization.of(context).translate("password"),
            suffixIcon: IconButton(
              onPressed: () {
                _bloc.add(LoginSecurePasswordEvent());
              },
              icon: Icon(
                _bloc.obscurePassword ? Icons.visibility : Icons.visibility_off,
                color: AppColors.gray,
              ),
            ),
            errorText: _bloc.passwordErrorMessage?.toString(),
          ),
        );
      },
    );
  }
}
