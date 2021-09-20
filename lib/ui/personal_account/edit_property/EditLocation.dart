import 'package:exservice/bloc/StatePusher.dart';
import 'package:exservice/models/common/Town.dart';
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

class EditLocation extends StatefulWidget {
  @override
  _EditLocationState createState() => _EditLocationState();
}

class _EditLocationState extends State<EditLocation> {
  final _loadPusher = StatePusher<bool>.behavior();
  final _groupPusher = StatePusher<Null>.publish();
  int _index;

  Town _option;
  List<Town> options;

  _fetchEdit() {
    if (_option == null) {
      Fluttertoast.showToast(
        msg: AppLocalization.of(context).trans("locationReq"),
      );
      return;
    }
    if (GetIt.I.get<AccountManager>().profile.user.town.id == _option.id) {
      Fluttertoast.showToast(
        msg: AppLocalization.of(context).trans("cannotSubmitTheSameLocation"),
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
                  townId: _option.id,
                );
            GetIt.I.get<AccountManager>().profile.user.town = _option;
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

  _fetch() async {
    options = apiConstant.towns;
    for (int index = 0; index < options.length; index++) {
      if (options[index].id ==
          GetIt.I.get<AccountManager>().profile.user.town.id) {
        _option = options[index];
        _index = index;
        _groupPusher.push();
        break;
      }
    }
  }

  @override
  void initState() {
    _fetch();
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
          AppLocalization.of(context).trans('changeLocation'),
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
                AppLocalization.of(context).trans("location"),
                style: AppTextStyle.mediumBlack,
              ),
            ),
          ),
          StreamBuilder<Null>(
            stream: _groupPusher.stream,
            builder: (context, snapshot) {
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
                    text: options[index].name,
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
