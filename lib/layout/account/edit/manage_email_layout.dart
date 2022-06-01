import 'package:exservice/bloc/account/manage_email_bloc/manage_email_bloc.dart';
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

class ManageEmailLayout extends StatefulWidget {
  const ManageEmailLayout({Key key}) : super(key: key);

  @override
  _ManageEmailLayoutState createState() => _ManageEmailLayoutState();
}

class _ManageEmailLayoutState extends State<ManageEmailLayout> {
  ManageEmailBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<ManageEmailBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalization.of(context).translate("email"),
        ),
        actions: [
          BlocBuilder<ManageEmailBloc, ManageEmailState>(
            buildWhen: (_, current) =>
                current is ManageEmailAwaitState ||
                current is ManageEmailErrorState ||
                current is ManageEmailAcceptState,
            builder: (context, state) {
              return IconButton(
                splashRadius: 25,
                icon: state is ManageEmailAwaitState
                    ? CupertinoActivityIndicator()
                    : Icon(Icons.check),
                onPressed: state is ManageEmailAwaitState
                    ? null
                    : () {
                        _bloc.add(ManageEmailCommitEvent());
                      },
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<ManageEmailBloc, ManageEmailState>(
        listenWhen: (_, current) =>
            current is ManageEmailAcceptState ||
            current is ManageEmailErrorState,
        listener: (context, state) async {
          if (state is ManageEmailAcceptState) {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => BlocProvider<VerificationBloc>(
                  create: (context) => VerificationBloc(
                    VerificationOnChangeEmailFactory(
                      state.session,
                      context.read<ProfileBloc>(),
                    ),
                  ),
                  child: VerificationLayout(),
                ),
              ),
            );
          } else if (state is ManageEmailErrorState) {
            showErrorBottomSheet(
              context,
              title: AppLocalization.of(context).translate("error"),
              message: Utils.resolveErrorMessage(state.error),
            );
          }
        },
        buildWhen: (_, current) =>
            current is ManageEmailValidateState ||
            current is ManageEmailSecurePasswordState,
        builder: (context, state) {
          return ExpandedSingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    AppLocalization.of(context)
                        .translate('update_email_address'),
                    style: Theme.of(context).primaryTextTheme.labelLarge,
                  ),
                  SizedBox(height: Sizer.vs2),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: TextField(
                      controller: _bloc.emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        errorText: _bloc.emailErrorMessage?.toString(),
                        labelText:
                            "${AppLocalization.of(context).translate("email")}*",
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
                          _bloc.add(ManageEmailShowPasswordEvent());
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
            ),
          );
        },
      ),
    );
  }
}
