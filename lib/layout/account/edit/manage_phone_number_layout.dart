import 'package:exservice/bloc/account/manage_phone_number_bloc/manage_phone_number_bloc.dart';
import 'package:exservice/bloc/auth/verification_bloc/verification_bloc.dart';
import 'package:exservice/bloc/profile_bloc/profile_bloc.dart';
import 'package:exservice/layout/auth/verification_layout.dart';
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

class ManagePhoneNumberLayout extends StatefulWidget {
  const ManagePhoneNumberLayout({Key key}) : super(key: key);

  @override
  _ManagePhoneNumberLayoutState createState() =>
      _ManagePhoneNumberLayoutState();
}

class _ManagePhoneNumberLayoutState extends State<ManagePhoneNumberLayout> {
  ManagePhoneNumberBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<ManagePhoneNumberBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalization.of(context).translate("mobile"),
        ),
        actions: [
          BlocBuilder<ManagePhoneNumberBloc, ManagePhoneNumberState>(
            buildWhen: (_, current) =>
                current is ManagePhoneNumberAwaitState ||
                current is ManagePhoneNumberErrorState ||
                current is ManagePhoneNumberAcceptState,
            builder: (context, state) {
              return IconButton(
                splashRadius: 25,
                icon: state is ManagePhoneNumberAwaitState
                    ? CupertinoActivityIndicator()
                    : Icon(Icons.check),
                onPressed: state is ManagePhoneNumberAwaitState
                    ? null
                    : () {
                        _bloc.add(ManagePhoneNumberCommitEvent());
                      },
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<ManagePhoneNumberBloc, ManagePhoneNumberState>(
        listenWhen: (_, current) =>
            current is ManagePhoneNumberAcceptState ||
            current is ManagePhoneNumberErrorState,
        listener: (context, state) async {
          if (state is ManagePhoneNumberAcceptState) {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => BlocProvider<VerificationBloc>(
                  create: (context) => VerificationBloc(
                    VerificationOnChangePhoneNumberFactory(
                      state.session,
                      context.read<ProfileBloc>(),
                    ),
                  ),
                  child: VerificationLayout(),
                ),
              ),
            );
          } else if (state is ManagePhoneNumberErrorState) {
            showErrorBottomSheet(
              context,
              title: AppLocalization.of(context).translate("error"),
              message: Utils.resolveErrorMessage(state.error),
            );
          }
        },
        buildWhen: (_, current) =>
            current is ManagePhoneNumberValidateState ||
            current is ManagePhoneNumberSecurePasswordState,
        builder: (context, state) {
          return ExpandedSingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        AppLocalization.of(context)
                            .translate('update_mobile_number'),
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(height: Sizer.vs2),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: TextField(
                          controller: _bloc.mobileNumberController,
                          keyboardType: TextInputType.phone,
                          maxLines: 1,
                          decoration: InputDecoration(
                            errorText: _bloc.mobileErrorMessage?.toString(),
                            labelText:
                                "${AppLocalization.of(context).translate("mobile_number")}*",
                          ),
                        ),
                      ),
                      SizedBox(height: Sizer.vs2),
                      DirectionalTextField(
                        controller: _bloc.passwordController,
                        obscureText: _bloc.obscurePassword,
                        maxLines: 1,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              _bloc.add(ManagePhoneNumberShowPasswordEvent());
                            },
                            icon: Icon(
                              _bloc.obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppColors.gray,
                            ),
                          ),
                          errorText: _bloc.passwordErrorMessage?.toString(),
                          labelText:
                              "${AppLocalization.of(context).translate("password")}*",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
