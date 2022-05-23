import 'package:exservice/renovation/bloc/account/change_password_bloc/change_password_bloc.dart';
import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/styles/app_colors.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:exservice/renovation/utils/utils.dart';
import 'package:exservice/renovation/widget/application/directional_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangePasswordLayout extends StatefulWidget {
  const ChangePasswordLayout({Key key}) : super(key: key);

  @override
  _ChangePasswordLayoutState createState() => _ChangePasswordLayoutState();
}

class _ChangePasswordLayoutState extends State<ChangePasswordLayout> {
  ChangePasswordBloc _bloc;
  MediaQueryData mediaQuery;

  @override
  void initState() {
    _bloc = BlocProvider.of<ChangePasswordBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        iconTheme: IconThemeData(color: AppColors.blue),
        centerTitle: true,
        title: Text(
          AppLocalization.of(context).trans('app_name'),
          style: AppTextStyle.largeBlack,
        ),
      ),
      backgroundColor: AppColors.white,
      body: BlocListener<ChangePasswordBloc, ChangePasswordState>(
        listener: (context, state) {
          if (state is OnChangePasswordState) {
            Fluttertoast.showToast(
              msg: AppLocalization.of(context).trans("password_updated"),
            );
          } else if (state is ChangePasswordErrorState) {
            Fluttertoast.showToast(msg: state.message);
          }
        },
        child: LayoutBuilder(
          builder: (context, constraint) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraint.maxHeight,
                ),
                child: Padding(
                  padding: EdgeInsets.all(mediaQuery.size.width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            AppLocalization.of(context)
                                .trans('change_password'),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          SizedBox(
                            height: Utils.verticalSpace(mediaQuery) * 3,
                          ),
                          getOldPasswordField(),
                          SizedBox(
                            height: Utils.verticalSpace(mediaQuery) * 2,
                          ),
                          getNewPasswordField(),
                          SizedBox(
                            height: Utils.verticalSpace(mediaQuery) * 2,
                          ),
                          getConfirmField(),
                          SizedBox(
                            height: Utils.verticalSpace(mediaQuery) * 2,
                          ),
                        ],
                      ),
                      BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: state is ChangePasswordAwaitState
                                ? null
                                : () {
                                    _bloc.add(OnChangePasswordEvent());
                                  },
                            child: state is ChangePasswordAwaitState
                                ? CupertinoActivityIndicator()
                                : Text(
                                    AppLocalization.of(context)
                                        .trans("change_password"),
                                  ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget getNewPasswordField() {
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
      buildWhen: (previous, current) {
        return current is ChangePasswordFormValidationState ||
            current is ChangePasswordShowNewPasswordState;
      },
      builder: (context, state) {
        return DirectionalTextField(
          controller: this._bloc.newPasswordController,
          keyboardType: TextInputType.visiblePassword,
          obscureText: this._bloc.obscureNewPassword,
          decoration: InputDecoration(
            labelText: "${AppLocalization.of(context).trans("new_password")}*",
            suffixIcon: IconButton(
              onPressed: () {
                this._bloc.add(ChangePasswordObscureNewPasswordEvent());
              },
              icon: Icon(
                this._bloc.obscureNewPassword
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: AppColors.gray,
                size: Utils.iconSize(mediaQuery),
              ),
            ),
            errorText: _bloc.errorNewPasswordMsg,
          ),
        );
      },
    );
  }

  Widget getOldPasswordField() {
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
      buildWhen: (previous, current) {
        return current is ChangePasswordFormValidationState ||
            current is ChangePasswordShowOldPasswordState;
      },
      builder: (context, state) {
        return DirectionalTextField(
          controller: this._bloc.oldPasswordController,
          keyboardType: TextInputType.visiblePassword,
          obscureText: this._bloc.obscureOldPassword,
          decoration: InputDecoration(
            labelText: "${AppLocalization.of(context).trans("old_password")}*",
            suffixIcon: IconButton(
              onPressed: () {
                this._bloc.add(ChangePasswordObscureOldPasswordEvent());
              },
              icon: Icon(
                this._bloc.obscureOldPassword
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: AppColors.gray,
                size: Utils.iconSize(mediaQuery),
              ),
            ),
            errorText: _bloc.errorOldPasswordMsg,
          ),
        );
      },
    );
  }

  Widget getConfirmField() {
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
      buildWhen: (previous, current) {
        return current is ChangePasswordFormValidationState ||
            current is ChangePasswordShowConfirmPasswordState;
      },
      builder: (context, state) {
        return DirectionalTextField(
          controller: this._bloc.confirmPasswordController,
          keyboardType: TextInputType.visiblePassword,
          obscureText: this._bloc.obscureConfirmPassword,
          decoration: InputDecoration(
            labelText:
                "${AppLocalization.of(context).trans("confirm_password")}*",
            suffixIcon: IconButton(
              onPressed: () {
                this._bloc.add(ChangePasswordObscureConfirmPasswordEvent());
              },
              icon: Icon(
                this._bloc.obscureConfirmPassword
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: AppColors.gray,
                size: Utils.iconSize(mediaQuery),
              ),
            ),
            errorText: _bloc.errorConfirmPasswordMsg,
          ),
        );
      },
    );
  }
}
