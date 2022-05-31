import 'package:exservice/bloc/account/change_password_bloc/change_password_bloc.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/utils/sizer.dart';
import 'package:exservice/utils/utils.dart';
import 'package:exservice/widget/application/directional_text_field.dart';
import 'package:exservice/widget/application/global_widgets.dart';
import 'package:exservice/widget/bottom_sheets/error_bottom_sheet.dart';
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
  var border = UnderlineInputBorder(
    borderSide: const BorderSide(color: AppColors.grayAccent),
  );
  var errorBorder = UnderlineInputBorder(
    borderSide: const BorderSide(color: AppColors.red),
  );

  @override
  void initState() {
    _bloc = BlocProvider.of<ChangePasswordBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalization.of(context).translate('change_password'),
        ),
        actions: [
          BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
            builder: (context, state) {
              return IconButton(
                splashRadius: 25,
                icon: state is ChangePasswordAwaitState
                    ? CupertinoActivityIndicator()
                    : Icon(Icons.check),
                onPressed: state is ChangePasswordAwaitState
                    ? null
                    : () {
                        _bloc.add(ChangePasswordCommitEvent());
                      },
              );
            },
          ),
        ],
      ),
      body: BlocListener<ChangePasswordBloc, ChangePasswordState>(
        listener: (context, state) {
          if (state is ChangePasswordAcceptState) {
            Fluttertoast.showToast(
              msg: AppLocalization.of(context).translate("password_updated"),
              toastLength: Toast.LENGTH_LONG,
            );
          } else if (state is ChangePasswordErrorState) {
            showErrorBottomSheet(
              context,
              title: AppLocalization.of(context).translate("error"),
              message: Utils.resolveErrorMessage(state.error),
            );
          }
        },
        child: ExpandedSingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(Sizer.vs2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: Sizer.vs2),
                    getOldPasswordField(),
                    SizedBox(height: Sizer.vs2),
                    getNewPasswordField(),
                    SizedBox(height: Sizer.vs2),
                    getConfirmField(),
                    SizedBox(height: Sizer.vs2),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getNewPasswordField() {
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
      buildWhen: (_, current) =>
          current is ChangePasswordValidationState ||
          current is ChangePasswordShowNewPasswordState,
      builder: (context, state) {
        var style = Theme.of(context).primaryTextTheme.bodyMedium;

        return DirectionalTextField(
          controller: _bloc.newPasswordController,
          keyboardType: TextInputType.visiblePassword,
          maxLines: 1,
          style: style,
          obscureText: _bloc.obscureNewPassword,
          decoration: InputDecoration(
            filled: false,
            border: border,
            enabledBorder: border,
            focusedBorder: border,
            errorBorder: errorBorder,
            labelText: AppLocalization.of(context).translate("new_password"),
            suffixIcon: IconButton(
              onPressed: () {
                _bloc.add(ChangePasswordObscureNewPasswordEvent());
              },
              icon: Icon(
                _bloc.obscureNewPassword
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: AppColors.gray,
              ),
            ),
            errorText: _bloc.errorNewPasswordMsg?.toString(),
          ),
        );
      },
    );
  }

  Widget getOldPasswordField() {
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
      buildWhen: (_, current) =>
          current is ChangePasswordValidationState ||
          current is ChangePasswordShowOldPasswordState,
      builder: (context, state) {
        var style = Theme.of(context).primaryTextTheme.bodyMedium;

        return DirectionalTextField(
          controller: _bloc.oldPasswordController,
          keyboardType: TextInputType.visiblePassword,
          maxLines: 1,
          style: style,
          obscureText: _bloc.obscureOldPassword,
          decoration: InputDecoration(
            filled: false,
            border: border,
            enabledBorder: border,
            focusedBorder: border,
            errorBorder: errorBorder,
            labelText: AppLocalization.of(context).translate("old_password"),
            suffixIcon: IconButton(
              onPressed: () {
                _bloc.add(ChangePasswordObscureOldPasswordEvent());
              },
              icon: Icon(
                _bloc.obscureOldPassword
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: AppColors.gray,
              ),
            ),
            errorText: _bloc.errorOldPasswordMsg?.toString(),
          ),
        );
      },
    );
  }

  Widget getConfirmField() {
    var style = Theme.of(context).primaryTextTheme.bodyMedium;
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
      buildWhen: (_, current) =>
          current is ChangePasswordValidationState ||
          current is ChangePasswordShowConfirmPasswordState,
      builder: (context, state) {
        return DirectionalTextField(
          controller: _bloc.confirmPasswordController,
          keyboardType: TextInputType.visiblePassword,
          style: style,
          obscureText: _bloc.obscureConfirmPassword,
          maxLines: 1,
          decoration: InputDecoration(
            filled: false,
            border: border,
            enabledBorder: border,
            focusedBorder: border,
            errorBorder: errorBorder,
            labelText:
                AppLocalization.of(context).translate("confirm_password"),
            suffixIcon: IconButton(
              onPressed: () {
                _bloc.add(ChangePasswordObscureConfirmPasswordEvent());
              },
              icon: Icon(
                _bloc.obscureConfirmPassword
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: AppColors.gray,
              ),
            ),
            errorText: _bloc.errorConfirmPasswordMsg?.toString(),
          ),
        );
      },
    );
  }
}
