import 'package:exservice/renovation/bloc/auth/register_bloc/register_bloc.dart';
import 'package:exservice/renovation/bloc/auth/verification_bloc/verification_bloc.dart';
import 'package:exservice/renovation/layout/auth/verification_layout.dart';
import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/styles/app_colors.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:exservice/renovation/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TitleFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(oldValue, newValue) {
    var text = newValue.text.split(" ").map((word) {
      if (word.length == 0) return word;
      if (word.length == 1) return word.toUpperCase();
      return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
    });
    return TextEditingValue(
      text: text.join(" "),
      selection: newValue.selection,
    );
  }
}

class CompleteRegisterLayout extends StatefulWidget {
  @override
  _CompleteRegisterLayoutState createState() => _CompleteRegisterLayoutState();
}

class _CompleteRegisterLayoutState extends State<CompleteRegisterLayout> {
  RegisterBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<RegisterBloc>(context);
    super.initState();
  }

  void _register() {
    _bloc.add(RegisterCommitEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listenWhen: (_, current) => current is RegisterCommittedState,
      listener: (context, state) {
        if (state is RegisterCommittedState) {
          Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => VerificationBloc(
                  context,
                  VerificationOnAuthFactory(state.session),
                ),
                child: VerificationLayout(),
              ),
            ),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Center(
                      child: Text(
                        AppLocalization.of(context).trans('name_password'),
                        style: AppTextStyle.largeBlackBold,
                      ),
                    ),
                    SizedBox(height: 20),
                    getUsernameField(),
                    SizedBox(height: 20),
                    getPasswordField(),
                    SizedBox(height: 20),
                    getSubmitButton(),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
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
            inputFormatters: [TitleFormatter()],
            decoration: InputDecoration(
              suffixIcon: GestureDetector(
                child: Icon(Icons.clear, color: AppColors.gray),
                onTap: () {
                  _bloc.usernameController.clear();
                },
              ),
              labelText: AppLocalization.of(context).trans('fullName'),
              labelStyle: AppTextStyle.largeBlue,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              errorText: _bloc.usernameErrorMessage,
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
              labelText: AppLocalization.of(context).trans("password"),
              labelStyle: AppTextStyle.largeBlue,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: IconButton(
                onPressed: () {
                  _bloc.add(RegisterSecurePasswordEvent());
                },
                icon: Icon(
                  _bloc.obscurePassword
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: AppColors.gray,
                  size: Utils.iconSize(MediaQuery.of(context)),
                ),
              ),
              errorText: _bloc.passwordErrorMessage,
            ),
          ),
        );
      },
    );
  }

  Widget getSubmitButton() {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (_, current) =>
          current is RegisterAwaitState ||
          current is RegisterCommittedState ||
          current is RegisterErrorState,
      builder: (context, state) {
        return ElevatedButton(
          child: state is RegisterAwaitState
              ? CupertinoActivityIndicator()
              : Text(
                  AppLocalization.of(context).trans('next'),
                  style: AppTextStyle.mediumWhite,
                ),
          onPressed: state is RegisterAwaitState ? null : _register,
        );
      },
    );
  }
}
