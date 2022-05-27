import 'package:exservice/bloc/account/switch_business_bloc/switch_business_bloc.dart';
import 'package:exservice/bloc/view/account_bloc/account_bloc.dart';
import 'package:exservice/controller/data_store.dart';
import 'package:exservice/layout/main_layout.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:exservice/utils/constant.dart';
import 'package:exservice/utils/utils.dart';
import 'package:exservice/widget/application/directional_text_field.dart';
import 'package:exservice/widget/application/global_widgets.dart';
import 'package:exservice/widget/bottom_sheets/error_bottom_sheet.dart';
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
            AppLocalization.of(context).translate("error"),
            state.message,
          );
        } else if (state is SwitchBusinessCommittedState) {
          Navigator.of(context).popUntil(ModalRoute.withName(MainLayout.route));
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: LayoutBuilder(builder: (context, constraints) {
            var _mediaQuery = MediaQuery.of(context);
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: BlocBuilder<SwitchBusinessBloc, SwitchBusinessState>(
                  buildWhen: (_, current) =>
                      current is SwitchBusinessValidationState,
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          SizedBox(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Center(
                                child: SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: ClipOval(
                                    child: OctoImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        BlocProvider.of<AccountBloc>(context).profile.profilePicture,
                                      ),
                                      progressIndicatorBuilder: (context, _) =>
                                          simpleShimmer,
                                      errorBuilder: (context, e, _) =>
                                          Image.asset(
                                        PLACEHOLDER,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "${AppLocalization.of(context).translate("companyName")}*",
                              ),
                              DirectionalTextField(
                                controller: _bloc.companyNameController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: AppLocalization.of(context)
                                      .translate("companyName"),
                                  errorText: _bloc.companyNameErrorMessage,
                                ),
                              ),
                              SizedBox(
                                height: Utils.verticalSpace(_mediaQuery) * 2,
                              ),
                              Text(
                                "${AppLocalization.of(context).translate("website")}*",
                              ),
                              DirectionalTextField(
                                controller: _bloc.websiteController,
                                keyboardType: TextInputType.url,
                                decoration: InputDecoration(
                                  hintText: AppLocalization.of(context)
                                      .translate("website"),
                                  errorText: _bloc.websiteErrorMessage,
                                ),
                              ),
                              SizedBox(
                                height: Utils.verticalSpace(_mediaQuery) * 2,
                              ),
                              Text(
                                "${AppLocalization.of(context).translate("bio")}*",
                              ),
                              DirectionalTextField(
                                controller: _bloc.bioController,
                                decoration: InputDecoration(
                                  hintText:
                                      AppLocalization.of(context).translate("bio"),
                                  errorText: _bloc.bioErrorMessage,
                                ),
                              ),
                            ],
                          ),
                          BlocBuilder<SwitchBusinessBloc, SwitchBusinessState>(
                            buildWhen: (_, current) =>
                                current is SwitchBusinessAwaitState ||
                                current is SwitchBusinessErrorState ||
                                current is SwitchBusinessCommittedState,
                            builder: (context, state) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: _mediaQuery.size.height * 0.04,
                                ),
                                child: ElevatedButton(
                                  child: state is SwitchBusinessAwaitState
                                      ? CupertinoActivityIndicator()
                                      : Text(
                                          AppLocalization.of(context)
                                              .translate('switch'),
                                          style: AppTextStyle.mediumWhite,
                                        ),
                                  onPressed: state is SwitchBusinessAwaitState
                                      ? null
                                      : _switchToBusiness,
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
