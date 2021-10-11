import 'package:exservice/renovation/bloc/account/business_info_bloc/business_info_bloc.dart';
import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/styles/app_colors.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:exservice/renovation/utils/utils.dart';
import 'package:exservice/renovation/widget/application/directional_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditBusinessInfoLayout extends StatefulWidget {
  @override
  _EditBusinessInfoLayoutState createState() => _EditBusinessInfoLayoutState();
}

class _EditBusinessInfoLayoutState extends State<EditBusinessInfoLayout> {
  BusinessInfoBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<BusinessInfoBloc>(context);
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
          AppLocalization.of(context).trans("app_name"),
          style: AppTextStyle.largeLobsterBlack,
        ),
      ),
      backgroundColor: AppColors.white,
      body: LayoutBuilder(
        builder: (context, constraint) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Profile and create account text
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "${AppLocalization.of(context).trans("companyName")}*",
                        ),
                        BlocBuilder<BusinessInfoBloc, BusinessInfoState>(
                          buildWhen: (_, current) =>
                              current is BusinessInfoValidateState ||
                              current is BusinessInfoResetState,
                          builder: (context, state) {
                            return DirectionalTextField(
                              controller: _bloc.companyNameController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: AppLocalization.of(context)
                                    .trans("companyName"),
                                errorText: _bloc.companyNameErrorMessage,
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          height: Utils.verticalSpace(_mediaQuery) * 2,
                        ),
                        Text(
                          "${AppLocalization.of(context).trans("website")}*",
                        ),
                        BlocBuilder<BusinessInfoBloc, BusinessInfoState>(
                          buildWhen: (_, current) =>
                              current is BusinessInfoValidateState ||
                              current is BusinessInfoResetState,
                          builder: (context, state) {
                            return DirectionalTextField(
                              controller: _bloc.websiteController,
                              keyboardType: TextInputType.url,
                              decoration: InputDecoration(
                                hintText: AppLocalization.of(context)
                                    .trans("website"),
                                errorText: _bloc.websiteErrorMessage,
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          height: Utils.verticalSpace(_mediaQuery) * 2,
                        ),
                        Text(
                          "${AppLocalization.of(context).trans("bio")}*",
                        ),
                        BlocBuilder<BusinessInfoBloc, BusinessInfoState>(
                          buildWhen: (_, current) =>
                              current is BusinessInfoValidateState ||
                              current is BusinessInfoResetState,
                          builder: (context, state) {
                            return DirectionalTextField(
                              controller: _bloc.bioController,
                              decoration: InputDecoration(
                                hintText:
                                    AppLocalization.of(context).trans("bio"),
                                errorText: _bloc.bioErrorMessage,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              _bloc.add(ResetBusinessInfoEvent());
                            },
                            style: ElevatedButton.styleFrom(
                              primary: AppColors.white,
                            ),
                            child: Text(
                              AppLocalization.of(context).trans("reset"),
                              style: AppTextStyle.mediumGray,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child:
                              BlocBuilder<BusinessInfoBloc, BusinessInfoState>(
                            builder: (context, state) {
                              return ElevatedButton(
                                onPressed: state is BusinessInfoAwaitState
                                    ? null
                                    : () {
                                        _bloc.add(UpdateBusinessInfoEvent());
                                      },
                                child: state is BusinessInfoAwaitState
                                    ? CupertinoActivityIndicator()
                                    : Text(
                                        AppLocalization.of(context)
                                            .trans("update"),
                                        style: AppTextStyle.mediumWhite,
                                      ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
