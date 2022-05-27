import 'package:exservice/bloc/auth/login_bloc/login_bloc.dart';
import 'package:exservice/bloc/auth/register_bloc/register_bloc.dart';
import 'package:exservice/layout/auth/complete_register_layout.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:exservice/utils/enums.dart';
import 'package:exservice/widget/button/page_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  void _register() async {
    _bloc.add(RegisterCheckAccountEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listenWhen: (_, current) => current is RegisterUniqueAccountState,
      listener: (context, state) {
        if (state is RegisterUniqueAccountState) {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => BlocProvider.value(
                value: _bloc,
                child: CompleteRegisterLayout(),
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
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white,
                            backgroundImage:
                                AssetImage('assets/images/ic_user.png'),
                          ),
                        ),
                        SizedBox(height: 15),
                        getTabBar(), //todo update
                        SizedBox(height: 20),
                        getAccountField(),
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
                        child: InkWell(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => LoginBloc(context),
                                  child: LoginLayout(),
                                ),
                              ),
                              (route) => false,
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                AppLocalization.of(context)
                                    .translate('had_account'),
                                style: AppTextStyle.smallGray,
                              ),
                              SizedBox(width: 5),
                              Text(
                                '${AppLocalization.of(context).translate('login')}.',
                                style: AppTextStyle.smallBlackBold,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget getTabBar() {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (_, current) => current is RegisterChangeIdentifierState,
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PageButton(
              text: AppLocalization.of(context).translate('phone'),
              disabled: _bloc.identifier != AccountRegistrationType.phone,
              onTap: () {
                FocusScope.of(context).unfocus();
                _bloc.add(RegisterChangeIdentifierEvent(
                  AccountRegistrationType.phone,
                ));
              },
            ),
            PageButton(
              text: AppLocalization.of(context).translate('email'),
              disabled: _bloc.identifier != AccountRegistrationType.email,
              onTap: () {
                FocusScope.of(context).unfocus();
                _bloc.add(RegisterChangeIdentifierEvent(
                  AccountRegistrationType.email,
                ));
              },
            ),
          ],
        );
      },
    );
  }

  Widget getAccountField() {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (_, current) =>
          current is RegisterValidationState ||
          current is RegisterChangeIdentifierState ||
          current is RegisterInitial,
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: TextField(
            controller: _bloc.accountController,
            keyboardType:
                _bloc.identifier == AccountRegistrationType.email
                    ? TextInputType.emailAddress
                    : TextInputType.phone,
            decoration: InputDecoration(
              suffixIcon: GestureDetector(
                child: Icon(Icons.clear, color: AppColors.gray),
                onTap: () {
                  _bloc.accountController.clear();
                },
              ),
              labelText: _bloc.identifier == AccountRegistrationType.email
                  ? AppLocalization.of(context).translate('email2')
                  : AppLocalization.of(context).translate('phoneNumber'),
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
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (_, current) =>
          current is RegisterAwaitCheckAccountState ||
          current is RegisterUniqueAccountState ||
          current is RegisterErrorState ||
          current is RegisterInitial,
      builder: (context, state) {
        return ElevatedButton(
          child: state is RegisterAwaitCheckAccountState
              ? CupertinoActivityIndicator()
              : Text(
                  AppLocalization.of(context).translate('next'),
                  style: AppTextStyle.mediumWhite,
                ),
          onPressed: state is RegisterAwaitCheckAccountState ? null : _register,
        );
      },
    );
  }
}
