import 'package:exservice/bloc/auth/login_bloc/login_bloc.dart';
import 'package:exservice/bloc/auth/reset_password_bloc/reset_password_bloc.dart';
import 'package:exservice/layout/auth/login_layout.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:exservice/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ResetPasswordLayout extends StatefulWidget {
  @override
  _ResetPasswordLayoutState createState() => _ResetPasswordLayoutState();
}

class _ResetPasswordLayoutState extends State<ResetPasswordLayout> {
  ResetPasswordBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<ResetPasswordBloc>(context);
    super.initState();
  }

  void _resetPassword() {
    _bloc.add(ResetPasswordCommitEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResetPasswordBloc, ResetPasswordState>(
      listenWhen: (_, current) =>
          current is ResetPasswordCommittedState ||
          current is ResetPasswordErrorState,
      listener: (context, state) {
        if (state is ResetPasswordCommittedState) {
          Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => LoginBloc(context),
                child: LoginLayout(),
              ),
            ),
            (route) => false,
          );
        } else if (state is ResetPasswordErrorState) {
          Fluttertoast.showToast(msg: state.message);
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
                            AppLocalization.of(context).translate('reset'),
                            style: AppTextStyle.xxLargeBlack,
                          ),
                        ),
                        SizedBox(height: 20),
                        getPasswordField(),
                        SizedBox(height: 20),
                        getConfirmField(),
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

  Widget getPasswordField() {
    return BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
      buildWhen: (_, current) =>
          current is ResetPasswordSecurePasswordState ||
          current is ResetPasswordValidationState,
      builder: (context, state) {
        return TextField(
          textDirection: TextDirection.ltr,
          controller: _bloc.passwordController,
          keyboardType: TextInputType.visiblePassword,
          obscureText: _bloc.obscurePassword,
          decoration: InputDecoration(
            labelText: AppLocalization.of(context).translate("newPassword"),
            labelStyle: AppTextStyle.largeBlue,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: IconButton(
              onPressed: () {
                _bloc.add(ResetPasswordSecurePasswordEvent());
              },
              icon: Icon(
                _bloc.obscurePassword ? Icons.visibility : Icons.visibility_off,
                color: AppColors.gray,
                size: Utils.iconSize(MediaQuery.of(context)),
              ),
            ),
            errorText: _bloc.passwordErrorMessage,
          ),
        );
      },
    );
  }

  Widget getConfirmField() {
    return BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
      buildWhen: (_, current) => current is ResetPasswordValidationState,
      builder: (context, state) {
        return TextField(
          textDirection: TextDirection.ltr,
          controller: _bloc.confirmController,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            labelText: AppLocalization.of(context).translate("confirmPassword"),
            labelStyle: AppTextStyle.largeBlue,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            errorText: _bloc.confirmErrorMessage,
          ),
        );
      },
    );
  }

  Widget getSubmitButton() {
    return BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
      buildWhen: (_, current) =>
          current is ResetPasswordAwaitState ||
          current is ResetPasswordCommittedState ||
          current is ResetPasswordErrorState,
      builder: (context, state) {
        return ElevatedButton(
          child: state is ResetPasswordAwaitState
              ? CupertinoActivityIndicator()
              : Text(
                  AppLocalization.of(context).translate('next'),
                  style: AppTextStyle.mediumWhite,
                ),
          onPressed: state is ResetPasswordAwaitState ? null : _resetPassword,
        );
      },
    );
  }
}
