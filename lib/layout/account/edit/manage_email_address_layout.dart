import 'package:exservice/bloc/account/manage_email_address_bloc/manage_email_address_bloc.dart';
import 'package:exservice/bloc/auth/verification_bloc/verification_bloc.dart';
import 'package:exservice/layout/auth/verification_layout.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:exservice/utils/sizer.dart';
import 'package:exservice/widget/application/directional_text_field.dart';
import 'package:exservice/widget/application/global_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageEmailAddressLayout extends StatefulWidget {
  const ManageEmailAddressLayout({Key key}) : super(key: key);

  @override
  _ManageEmailAddressLayoutState createState() =>
      _ManageEmailAddressLayoutState();
}

class _ManageEmailAddressLayoutState extends State<ManageEmailAddressLayout> {
  ManageEmailAddressBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<ManageEmailAddressBloc>(context);
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
          BlocBuilder<ManageEmailAddressBloc, ManageEmailAddressState>(
            builder: (context, state) {
              return IconButton(
                splashRadius: 25,
                icon: state is ManageEmailAddressAwaitState
                    ? CupertinoActivityIndicator()
                    : Icon(Icons.check),
                onPressed: state is ManageEmailAddressAwaitState
                    ? null
                    : () {
                        _bloc.add(ManageEmailAddressCommitEvent());
                      },
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<ManageEmailAddressBloc, ManageEmailAddressState>(
        listenWhen: (_, current) => current is ManageEmailAddressAcceptState,
        listener: (context, state) async {
          if (state is ManageEmailAddressAcceptState) {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => BlocProvider<VerificationBloc>(
                  create: (context) => VerificationBloc(
                    VerificationOnChangeEmailAddressFactory(state.session),
                  ),
                  child: VerificationLayout(),
                ),
              ),
            );
          }
        },
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
                          _bloc.add(ManageEmailAddressShowPasswordEvent());
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
