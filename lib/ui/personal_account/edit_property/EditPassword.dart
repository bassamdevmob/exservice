import 'package:exservice/bloc/StatePusher.dart';
import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/styles/app_colors.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:exservice/resources/api/ApiProviderDelegate.dart';
import 'package:exservice/widget/application/AppTextField.dart';
import 'package:exservice/widget/dialog/ConfirmDialog.dart';
import 'package:exservice/widget/dialog/NoteDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:string_validator/string_validator.dart' as validator;

class EditPassword extends StatefulWidget {
  @override
  _EditPasswordState createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword>
    with WidgetsBindingObserver {
  final _opwController = TextEditingController();
  final _npwController = TextEditingController();
  final _cpwController = TextEditingController();
  final _loadPusher = StatePusher<bool>.behavior();
  final _validatorPusher = StatePusher<String>.publish();

  _fetchEdit() {
    if (!validator.isLength(_npwController.text, 4)) {
      Fluttertoast.showToast(
        msg: AppLocalization.of(context).trans("passwordInvalid"),
      );
      return;
    }
    FocusScope.of(context).unfocus();
    showDialog(
      context: context,
      builder: (dialogContext) => ConfirmDialog(
        description: AppLocalization.of(context).trans("edit_profile_warning"),
        onTap: () async {
          Navigator.of(dialogContext).pop();
          _loadPusher.push(true);
          try {
            await GetIt.I.get<ApiProviderDelegate>().fetchUpdatePassword(
                  context,
                  _opwController.text,
                  _npwController.text,
                  _cpwController.text,
                );
            Fluttertoast.showToast(
              msg: AppLocalization.of(context).trans("edited"),
            );
            Navigator.of(context).pop();
          } catch (e) {
            showDialog(
              context: context,
              builder: (context) => NoteDialog.error(
                e.toString(),
                onTap: () => Navigator.of(context).pop(),
              ),
            );
          } finally {
            _loadPusher.push(false);
          }
        },
      ),
    );
  }

  _listener() {
    if (!validator.isLength(_npwController.text, 4)) {
      _validatorPusher
          .push(AppLocalization.of(context).trans("passwordInvalid"));
    } else {
      _validatorPusher.push();
    }
  }

  @override
  void initState() {
    _npwController.addListener(_listener);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      FocusScope.of(context).unfocus();
    }
  }

  @override
  void dispose() {
    _npwController.removeListener(_listener);
    _npwController.dispose();
    _cpwController.dispose();
    _opwController.dispose();
    _loadPusher.dispose();
    _validatorPusher.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.grayAccentLight,
        title: Text(
          AppLocalization.of(context).trans('changePassword'),
          style: AppTextStyle.largeBlack,
        ),
        actions: <Widget>[
          getActionButton(),
          SizedBox(width: 5),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalization.of(context).trans("password"),
                  style: AppTextStyle.mediumBlack,
                ),
              ),
              SizedBox(height: 25),
              AppTextField(
                hint: AppLocalization.of(context).trans("currentPassword"),
                backgroundColor: AppColors.transparent,
                borderType: AppInputFieldBorder.outlineInputBorder,
                controller: _opwController,
                padding: EdgeInsets.symmetric(horizontal: 10),
                bioStyle: AppTextStyle.mediumGray,
                style: AppTextStyle.mediumBlack,
                focusColor: AppColors.gray,
                borderColor: AppColors.gray,
                maxLines: 1,
                secured: true,
              ),
              SizedBox(height: 15),
              StreamBuilder<String>(
                  stream: _validatorPusher.stream,
                  builder: (context, snapshot) {
                    return AppTextField(
                      hint: AppLocalization.of(context).trans("newPassword"),
                      secured: true,
                      errorText: snapshot.data,
                      backgroundColor: AppColors.transparent,
                      borderType: AppInputFieldBorder.outlineInputBorder,
                      controller: _npwController,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      bioStyle: AppTextStyle.mediumGray,
                      style: AppTextStyle.mediumBlack,
                      focusColor: AppColors.gray,
                      borderColor: AppColors.gray,
                      maxLines: 1,
                    );
                  }),
              SizedBox(height: 15),
              AppTextField(
                hint: AppLocalization.of(context).trans("confirmPassword"),
                backgroundColor: AppColors.transparent,
                borderType: AppInputFieldBorder.outlineInputBorder,
                controller: _cpwController,
                padding: EdgeInsets.symmetric(horizontal: 10),
                bioStyle: AppTextStyle.mediumGray,
                style: AppTextStyle.mediumBlack,
                focusColor: AppColors.gray,
                borderColor: AppColors.gray,
                maxLines: 1,
                secured: true,
              ),
              SizedBox(height: 15),
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {}, //todo forget password
                  behavior: HitTestBehavior.opaque,
                  child: Text(
                    AppLocalization.of(context).trans("forgotPassword"),
                    style: AppTextStyle.mediumBlack,
                  ),
                ),
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  Widget getActionButton() {
    return StreamBuilder<bool>(
      stream: _loadPusher.stream,
      builder: (context, snapshot) {
        return InkWell(
          onTap: () async {
            _fetchEdit();
          },
          borderRadius: BorderRadius.circular(100),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: snapshot.data == true
                ? SizedBox(
                    child: CupertinoActivityIndicator(),
                    height: 20,
                  )
                : Icon(
                    Icons.check,
                    color: AppColors.green,
                  ),
          ),
        );
      },
    );
  }
}
