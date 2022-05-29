import 'package:exservice/bloc/account/manage_phone_number_bloc/manage_phone_number_bloc.dart';
import 'package:exservice/bloc/auth/verification_bloc/verification_bloc.dart';
import 'package:exservice/layout/auth/verification_layout.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:exservice/utils/global.dart';
import 'package:exservice/utils/utils.dart';
import 'package:exservice/widget/application/directional_text_field.dart';
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
      body: BlocListener<ManagePhoneNumberBloc, ManagePhoneNumberState>(
        listenWhen: (_, current) => current is ManagePhoneNumberCommittedState,
        listener: (context, state) async {
          if (state is ManagePhoneNumberCommittedState) {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => BlocProvider<VerificationBloc>(
                  create: (context) => VerificationBloc(
                    VerificationOnChangePhoneNumberFactory(state.session),
                  ),
                  child: VerificationLayout(),
                ),
              ),
            );
          }
        },
        child: BlocBuilder<ManagePhoneNumberBloc, ManagePhoneNumberState>(
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
                                  .translate('update_mobile_number'),
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            SizedBox(
                              height: Utils.verticalSpace(_mediaQuery) * 3,
                            ),
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: TextField(
                                controller: _bloc.mobileNumberController,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [phoneNumberFormatter],
                                decoration: InputDecoration(
                                  errorText: _bloc.mobileNumberMsg,
                                  labelText:
                                      "${AppLocalization.of(context).translate("mobile_number")}*",
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
                                        ManagePhoneNumberShowPasswordEvent());
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
                          onPressed: state is ManagePhoneNumberAwaitState
                              ? null
                              : () {
                                  _bloc.add(ManagePhoneNumberCommitEvent());
                                },
                          child: state is ManagePhoneNumberAwaitState
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
