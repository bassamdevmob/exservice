import 'package:exservice/helper/AppConstant.dart';
import 'package:exservice/renovation/bloc/account/switch_business_bloc/switch_business_bloc.dart';
import 'package:exservice/renovation/controller/data_store.dart';
import 'package:exservice/renovation/layout/main_layout.dart';
import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/styles/app_colors.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:exservice/renovation/widget/bottom_sheets/error_bottom_sheet.dart';
import 'package:exservice/widget/component/AppShimmers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octo_image/octo_image.dart';

class SwitchBusinessLayout extends StatefulWidget {
  @override
  _SwitchBusinessLayoutState createState() => _SwitchBusinessLayoutState();
}

class _SwitchBusinessLayoutState extends State<SwitchBusinessLayout>
    with WidgetsBindingObserver {
  SwitchBusinessBloc _bloc;

  var border = UnderlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: BorderSide(color: AppColors.gray),
  );

  var focusedBorder = UnderlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: BorderSide(color: AppColors.blue),
  );

  @override
  void initState() {
    _bloc = BlocProvider.of<SwitchBusinessBloc>(context);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted) return;
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      FocusScope.of(context).unfocus();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  _switchToBusiness() {
    _bloc.add(SwitchBusinessCommitEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SwitchBusinessBloc, SwitchBusinessState>(
      listenWhen: (_, current) =>
          current is SwitchBusinessCommittedState ||
          current is SwitchBusinessErrorState,
      listener: (context, state) {
        if (state is SwitchBusinessErrorState) {
          showErrorBottomSheet(
            context,
            AppLocalization.of(context).trans("error"),
            state.message,
          );
        } else if (state is SwitchBusinessCommittedState) {
          Navigator.of(context).popUntil(ModalRoute.withName(MainLayout.route));
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: BlocBuilder<SwitchBusinessBloc, SwitchBusinessState>(
                  buildWhen: (_, current) =>
                      current is SwitchBusinessValidationState,
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(height: 10),
                        Center(
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: ClipOval(
                              child: OctoImage(
                                fit: BoxFit.cover,
                                image:
                                    NetworkImage(DataStore.instance.user.logo),
                                progressIndicatorBuilder: (context, _) =>
                                    CustomShimmer.normal(),
                                errorBuilder: (context, e, _) => Image.asset(
                                  AppConstant.placeholder,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: TextField(
                            controller: _bloc.companyNameController,
                            decoration: InputDecoration(
                              labelText: AppLocalization.of(context)
                                  .trans("companyName"),
                              labelStyle: AppTextStyle.largeBlue,
                              errorText: _bloc.companyNameErrorMessage,
                              border: border,
                              focusedBorder: focusedBorder,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: TextField(
                            controller: _bloc.websiteController,
                            keyboardType: TextInputType.url,
                            decoration: InputDecoration(
                              labelText:
                                  AppLocalization.of(context).trans("website"),
                              labelStyle: AppTextStyle.largeBlue,
                              errorText: _bloc.websiteErrorMessage,
                              border: border,
                              focusedBorder: focusedBorder,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          child: TextField(
                            controller: _bloc.phoneNumberController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: AppLocalization.of(context)
                                  .trans("phone_number"),
                              labelStyle: AppTextStyle.largeBlue,
                              errorText: _bloc.phoneNumberErrorMessage,
                              border: border,
                              focusedBorder: focusedBorder,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          child: TextField(
                            controller: _bloc.bioController,
                            decoration: InputDecoration(
                              labelText:
                                  AppLocalization.of(context).trans("bio"),
                              labelStyle: AppTextStyle.largeBlue,
                              errorText: _bloc.bioErrorMessage,
                              border: border,
                              focusedBorder: focusedBorder,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          }),
        ),
        bottomNavigationBar: BottomAppBar(
          child: BlocBuilder<SwitchBusinessBloc, SwitchBusinessState>(
            buildWhen: (_, current) =>
                current is SwitchBusinessAwaitState ||
                current is SwitchBusinessErrorState ||
                current is SwitchBusinessCommittedState,
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: state is SwitchBusinessAwaitState
                        ? CupertinoActivityIndicator()
                        : Text(
                            AppLocalization.of(context).trans('switch'),
                            style: AppTextStyle.mediumWhite,
                          ),
                  ),
                  onPressed: state is SwitchBusinessAwaitState
                      ? null
                      : _switchToBusiness,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
