import 'package:exservice/bloc/StatePusher.dart';
import 'package:exservice/models/common/User.dart';
import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/styles/app_colors.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:exservice/resources/AccountManager.dart';
import 'package:exservice/resources/ApiConstant.dart';
import 'package:exservice/resources/api/ApiProviderDelegate.dart';
import 'package:exservice/widget/component/AnimatedAvatar.dart';
import 'package:exservice/widget/dialog/ConfirmDialog.dart';
import 'package:exservice/widget/dialog/NoteDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';

class EditType extends StatefulWidget {
  @override
  _EditTypeState createState() => _EditTypeState();
}

class _EditTypeState extends State<EditType> {
  final _loadPusher = StatePusher<bool>.behavior();
  final _groupPusher = StatePusher<Null>.behavior();

  int _index;
  UserType _option;
  List<UserType> options;

  _fetchEdit() {
    if (_option == null) {
      Fluttertoast.showToast(
        msg: AppLocalization.of(context).trans("TypeReq"),
      );
      return;
    }
    if (GetIt.I.get<AccountManager>().profile.user.type.id == _option.id) {
      Fluttertoast.showToast(
        msg: AppLocalization.of(context).trans("cannotSubmitTheSameType"),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (dialogContext) => ConfirmDialog(
        description: AppLocalization.of(context).trans("edit_profile_warning"),
        onTap: () async {
          Navigator.of(dialogContext).pop();
          _loadPusher.push(true);
          try {
            await GetIt.I.get<ApiProviderDelegate>().fetchEditProfile(
                  context,
                  typeId: _option.id,
                );
            GetIt.I.get<AccountManager>().profile.user.type = _option;
            GetIt.I.get<AccountManager>().profile.user.type.id = _option.id;
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

  @override
  void initState() {
    options = apiConstant.userTypes;
    super.initState();
  }

  @override
  void dispose() {
    _loadPusher.dispose();
    _groupPusher.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.grayAccentLight,
        title: Text(
          AppLocalization.of(context).trans('changeType'),
          style: AppTextStyle.largeBlack,
        ),
        actions: <Widget>[
          getActionButton(),
          SizedBox(width: 5),
        ],
      ),
      body: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                AppLocalization.of(context).trans("companyType"),
                style: AppTextStyle.mediumBlack,
              ),
            ),
          ),
          StreamBuilder<Null>(
            stream: _groupPusher.stream,
            builder: (context, snapshot) {
              // if (snapshot.hasError) {
              //   return ReloadPlaceHolder(
              //     color: AppColors.blue,
              //     text: snapshot.error,
              //     onTap: () => _fetch(),
              //   );
              // }
              // if (!apiConstant.initialized) {
              //   return Center(
              //     child: Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: CircularProgressIndicator(),
              //     ),
              //   );
              // }
              return AnimatedAvatarGroup(
                checked: _index,
                padding: EdgeInsets.symmetric(horizontal: 15),
                duration: Duration(milliseconds: 200),
                curve: Curves.linear,
                itemCount: options.length,
                onIndexChanged: (index) {
                  if (_option != null && options[index].id == _option.id) {
                    Fluttertoast.showToast(
                        msg:
                            AppLocalization.of(context).trans("requiredField"));
                    return;
                  }
                  _option = options[index];
                  _index = index;
                  _groupPusher.push();
                },
                builder: (context, index) {
                  return GroupedAnimatedAvatar(
                    text: options[index].title,
                    padding:
                        EdgeInsets.only(top: 5, right: 5, left: 5, bottom: 3),
                    inactiveStyle: AppTextStyle.mediumBlack,
                    activeStyle: AppTextStyle.mediumBlue,
                    width: 50,
                    space: 10,
                  );
                },
              );
            },
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget getActionButton() {
    return StreamBuilder<bool>(
      stream: _loadPusher.stream,
      builder: (context, snapshot) {
        return InkWell(
          onTap: snapshot.data == true ? null : _fetchEdit,
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
