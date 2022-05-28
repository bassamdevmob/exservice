import 'package:exservice/bloc/account/manage_email_address_bloc/manage_email_address_bloc.dart';
import 'package:exservice/bloc/auth/verification_bloc/verification_bloc.dart';
import 'package:exservice/layout/auth/verification_layout.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:exservice/utils/utils.dart';
import 'package:exservice/widget/application/directional_text_field.dart';
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
    var _mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        iconTheme: IconThemeData(color: AppColors.blue),
        centerTitle: true,
        title: Text(
          AppLocalization.of(context).translate("app_name"),
          style: AppTextStyle.largeLobsterBlack,
        ),
      ),
      body: BlocListener<ManageEmailAddressBloc, ManageEmailAddressState>(
        listenWhen: (_, current) => current is ManageEmailAddressCommittedState,
        listener: (context, state) async {
          if (state is ManageEmailAddressCommittedState) {
            Navigator.of(context).push(
              MaterialPageRoute(
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
        child: BlocBuilder<ManageEmailAddressBloc, ManageEmailAddressState>(
          builder: (context, state) {
            return LayoutBuilder(builder: (context, constraint) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraint.maxHeight,
                  ),
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
                                  .translate('update_email_address'),
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            SizedBox(
                              height: Utils.verticalSpace(_mediaQuery) * 3,
                            ),
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: TextField(
                                controller: _bloc.mobileNumberController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  errorText: _bloc.mobileNumberMsg,
                                  labelText:
                                  "${AppLocalization.of(context).translate("email_address")}*",
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                                  labelStyle: AppTextStyle.xlargeBlue,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: Utils.verticalSpace(_mediaQuery) * 3,
                            ),
                            DirectionalTextField(
                              controller: _bloc.passwordController,
                              obscureText: _bloc.obscurePassword,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    _bloc.add(
                                        ManageEmailAddressShowPasswordEvent());
                                  },
                                  icon: Icon(
                                    _bloc.obscurePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: AppColors.gray,
                                    size:
                                    Utils.iconSize(MediaQuery.of(context)),
                                  ),
                                ),
                                errorText: _bloc.passwordMsg,
                                labelText:
                                "${AppLocalization.of(context).translate("password")}*",
                                floatingLabelBehavior:
                                FloatingLabelBehavior.always,
                                labelStyle: AppTextStyle.xlargeBlue,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Utils.verticalSpace(_mediaQuery),
                        ),
                        ElevatedButton(
                          onPressed: state is ManageEmailAddressAwaitState
                              ? null
                              : () {
                            _bloc.add(ManageEmailAddressCommitEvent());
                          },
                          child: state is ManageEmailAddressAwaitState
                              ? CupertinoActivityIndicator()
                              : Text(
                            AppLocalization.of(context).translate("update"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
          },
        ),
      ),
    );
  }
}
