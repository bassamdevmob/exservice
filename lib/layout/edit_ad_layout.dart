import 'package:exservice/bloc/edit_ad_bloc/edit_ad_bloc.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:exservice/utils/utils.dart';
import 'package:exservice/widget/application/global_widgets.dart';
import 'package:exservice/widget/bottom_sheets/error_bottom_sheet.dart';
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
    return BlocListener<EditAdBloc, EditAdState>(
      listenWhen: (_, current) =>
          current is EditAdErrorState || current is EditAdAcceptState,
      listener: (context, state) {
        if (state is EditAdErrorState) {
          showErrorBottomSheet(
            context,
            title: AppLocalization.of(context).translate("error"),
            message: Utils.resolveErrorMessage(state.error),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalization.of(context).translate('edit_ad'),
          ),
          actions: [
            BlocBuilder<EditAdBloc, EditAdState>(
              buildWhen: (_, current) =>
                  current is EditAdAwaitState ||
                  current is EditAdErrorState ||
                  current is EditAdAcceptState,
              builder: (context, state) {
                if (state is EditAdAwaitState)
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CupertinoActivityIndicator(),
                  );
                return IconButton(
                  splashRadius: 25,
                  icon: Icon(Icons.check),
                  onPressed: () {
                    _bloc.add(FetchEditAdEvent());
                  },
                );
              },
            )
          ],
        ),
        body: ExpandedSingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 20),
                BlocBuilder<EditAdBloc, EditAdState>(
                  buildWhen: (_, current) => current is EditAdValidationState,
                  builder: (context, state) {
                    return TextField(
                      controller: _bloc.titleController,
                      decoration: InputDecoration(
                        labelText:
                            AppLocalization.of(context).translate('title'),
                        labelStyle: AppTextStyle.largeBlue,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        errorText: _bloc.titleErrorMessage?.toString(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                BlocBuilder<EditAdBloc, EditAdState>(
                  buildWhen: (_, current) => current is EditAdValidationState,
                  builder: (context, state) {
                    return TextField(
                      controller: _bloc.descriptionController,
                      maxLines: null,
                      decoration: InputDecoration(
                        labelText: AppLocalization.of(context)
                            .translate('description'),
                        labelStyle: AppTextStyle.largeBlue,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        errorText: _bloc.descriptionErrorMessage?.toString(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
