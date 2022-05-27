import 'package:exservice/bloc/default/edit_ad_bloc/edit_ad_bloc.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:exservice/widget/dialogs/error_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditAdLayout extends StatefulWidget {
  @override
  _EditAdLayoutState createState() => _EditAdLayoutState();
}

class _EditAdLayoutState extends State<EditAdLayout> {
  EditAdBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<EditAdBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _mediaQuery = MediaQuery.of(context);
    return BlocListener<EditAdBloc, EditAdState>(
      listenWhen: (_, current) => current is EditAdErrorState,
      listener: (context, state) {
        if (state is EditAdErrorState) {
          showDialog(
            context: context,
            builder: (ctx) => ErrorDialog(state.message),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.white,
          iconTheme: IconThemeData(color: AppColors.blue),
          centerTitle: true,
          title: Text(
            AppLocalization.of(context).translate('app_name'),
            style: AppTextStyle.largeBlack,
          ),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(height: 20),
                        BlocBuilder<EditAdBloc, EditAdState>(
                          buildWhen: (_, current) =>
                              current is EditAdValidationState,
                          builder: (context, state) {
                            return TextField(
                              controller: _bloc.titleController,
                              decoration: InputDecoration(
                                labelText:
                                    AppLocalization.of(context).translate('title'),
                                labelStyle: AppTextStyle.largeBlue,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                errorText: _bloc.titleErrorMessage,
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 20),
                        BlocBuilder<EditAdBloc, EditAdState>(
                          buildWhen: (_, current) =>
                              current is EditAdValidationState,
                          builder: (context, state) {
                            return TextField(
                              controller: _bloc.descriptionController,
                              maxLines: null,
                              decoration: InputDecoration(
                                labelText:
                                    AppLocalization.of(context).translate('desc'),
                                labelStyle: AppTextStyle.largeBlue,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                errorText: _bloc.descriptionErrorMessage,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    BlocBuilder<EditAdBloc, EditAdState>(
                      buildWhen: (_, current) =>
                          current is EditAdAwaitState ||
                          current is EditAdErrorState ||
                          current is EditAdCommittedState,
                      builder: (context, state) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: _mediaQuery.size.height * 0.04,
                          ),
                          child: ElevatedButton(
                            child: state is EditAdAwaitState
                                ? CupertinoActivityIndicator()
                                : Text(
                                    AppLocalization.of(context).translate('update'),
                                    style: AppTextStyle.mediumWhite,
                                  ),
                            onPressed: state is EditAdAwaitState ? null : _edit,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  _edit() {
    _bloc.add(FetchEditAdEvent());
  }
}
