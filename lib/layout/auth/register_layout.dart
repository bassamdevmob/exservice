import 'package:exservice/bloc/application_bloc/application_cubit.dart';
import 'package:exservice/bloc/auth/login_bloc/login_bloc.dart';
import 'package:exservice/bloc/auth/register_bloc/register_bloc.dart';
import 'package:exservice/bloc/auth/verification_bloc/verification_bloc.dart';
import 'package:exservice/layout/auth/verification_layout.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:exservice/utils/utils.dart';
import 'package:exservice/widget/application/global_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'login_layout.dart';

class RegisterLayout extends StatefulWidget {
  static const route = "/register";

  @override
  _RegisterLayoutState createState() => _RegisterLayoutState();
}

class _RegisterLayoutState extends State<RegisterLayout> {
  RegisterBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<RegisterBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listenWhen: (_, current) =>
          current is RegisterAcceptState || current is RegisterErrorState,
      listener: (context, state) {
        if (state is RegisterAcceptState) {
          Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => VerificationBloc(
                  VerificationOnAuthFactory(state.session),
                ),
                child: VerificationLayout(),
              ),
            ),
            (route) => false,
          );
        } else if (state is RegisterErrorState) {
          Fluttertoast.showToast(msg: Utils.resolveErrorMessage(state.error));
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
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    getUsernameField(),
                    SizedBox(height: 20),
                    getPasswordField(),
                    SizedBox(height: 20),
                    getSubmitButton(),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
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
                          AppLocalization.of(context).translate('had_account'),
                          style: AppTextStyle.smallGray,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => LoginBloc(),
                                  child: LoginLayout(),
                                ),
                              ),
                              (route) => false,
                            );
                          },
                          child: Text(
                            '${AppLocalization.of(context).translate('login')}.',
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

  Widget getAccountField() {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (_, current) => current is RegisterValidationState,
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: TextField(
            controller: _bloc.accountController,
            decoration: InputDecoration(
              hintText:
                  AppLocalization.of(context).translate("email_phone_number"),
              suffixIcon: GestureDetector(
                child: Icon(Icons.clear, color: AppColors.gray),
                onTap: () {
                  _bloc.accountController.clear();
                },
              ),
              errorText: _bloc.accountErrorMessage?.toString(),
            ),
          ),
        );
      },
    );
  }

  Widget getUsernameField() {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (_, current) => current is RegisterValidationState,
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: TextField(
            controller: _bloc.usernameController,
            inputFormatters: [UsernameFormatter()],
            decoration: InputDecoration(
              suffixIcon: GestureDetector(
                child: Icon(Icons.clear, color: AppColors.gray),
                onTap: () {
                  _bloc.usernameController.clear();
                },
              ),
              hintText: AppLocalization.of(context).translate('username'),
              errorText: _bloc.usernameErrorMessage?.toString(),
            ),
          ),
        );
      },
    );
  }

  Widget getPasswordField() {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (_, current) =>
          current is RegisterValidationState ||
          current is RegisterSecurePasswordState,
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: TextField(
            textDirection: TextDirection.ltr,
            controller: _bloc.passwordController,
            keyboardType: TextInputType.visiblePassword,
            obscureText: _bloc.obscurePassword,
            decoration: InputDecoration(
              hintText: AppLocalization.of(context).translate('password'),
              suffixIcon: IconButton(
                onPressed: () {
                  _bloc.add(RegisterSecurePasswordEvent());
                },
                icon: Icon(
                  _bloc.obscurePassword
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: AppColors.gray,
                ),
              ),
              errorText: _bloc.passwordErrorMessage?.toString(),
            ),
          ),
        );
      },
    );
  }

  Widget getSubmitButton() {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (_, current) =>
          current is RegisterAcceptState ||
          current is RegisterErrorState ||
          current is RegisterAwaitState,
      builder: (context, state) {
        return ElevatedButton(
          child: state is RegisterAwaitState
              ? CupertinoActivityIndicator()
              : Text(
                  AppLocalization.of(context).translate('next'),
                  style: AppTextStyle.mediumWhite,
                ),
          onPressed: state is RegisterAwaitState
              ? null
              : () {
                  _bloc.add(RegisterCommitEvent());
                },
        );
      },
    );
  }
}
