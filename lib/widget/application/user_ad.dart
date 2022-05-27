import 'package:exservice/models/entity/ad_model.dart';
import 'package:exservice/bloc/account/account_ads_bloc/account_ads_cubit.dart';
import 'package:exservice/bloc/ad_details_bloc/ad_details_bloc.dart';
import 'package:exservice/bloc/edit_ad_bloc/edit_ad_bloc.dart';
import 'package:exservice/bloc/profile_bloc/profile_bloc.dart';
import 'package:exservice/layout/ad_details_layout.dart';
import 'package:exservice/layout/edit_ad_layout.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:exservice/utils/enums.dart';
import 'package:exservice/widget/application/ad_details.dart';
import 'package:exservice/widget/application/ad_media.dart';
import 'package:exservice/widget/bottom_sheets/error_bottom_sheet.dart';
import 'package:exservice/widget/button/app_button.dart';
import 'package:exservice/widget/dialogs/confirm_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserAd extends StatefulWidget {
  final AdModel ad;

  const UserAd(this.ad, {Key key}) : super(key: key);

  @override
  _UserAdState createState() => _UserAdState();
}

class _UserAdState extends State<UserAd> {
  AccountAdsCubit _bloc;
  ProfileBloc _accountBloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<AccountAdsCubit>(context);
    _accountBloc = BlocProvider.of<ProfileBloc>(context);
    super.initState();
  }

  bool deleteLoading = false;
  bool statusLoading = false;

  _delete() {
    showDialog(
      context: context,
      builder: (ctx) => ConfirmDialog(
        text: AppLocalization.of(context).translate("confirmDelete"),
        onTap: () {
          Navigator.of(ctx).pop();
          setState(() => deleteLoading = true);
          _bloc.removeAd(widget.ad).then((_) {
            Fluttertoast.showToast(
              msg: AppLocalization.of(context).translate("deleted"),
            );
          }).catchError((e) {
            showErrorBottomSheet(
                context, AppLocalization.of(context).translate("error"), "$e");
          }).whenComplete(() {
            setState(() => deleteLoading = false);
          });
        },
      ),
    );
  }

  _activate() {
    showDialog(
      context: context,
      builder: (ctx) => ConfirmDialog(
        text: AppLocalization.of(context).translate("confirmActivate"),
        onTap: () {
          Navigator.of(ctx).pop();
          setState(() => statusLoading = true);
          _bloc.activateAd(widget.ad).then((_) {
            _accountBloc.model.statistics.activeAdsCount++;
            _accountBloc.model.statistics.inactiveAdsCount--;
            _accountBloc.add(ProfileRefreshEvent());
            Fluttertoast.showToast(
              msg: AppLocalization.of(context).translate("activated"),
            );
          }).catchError((e) {
            showErrorBottomSheet(
                context, AppLocalization.of(context).translate("error"), "$e");
          }).whenComplete(() {
            setState(() => statusLoading = false);
          });
        },
      ),
    );
  }

  _pause() {
    showDialog(
      context: context,
      builder: (ctx) => ConfirmDialog(
        text: AppLocalization.of(context).translate("confirmPause"),
        onTap: () {
          Navigator.of(ctx).pop();
          setState(() => statusLoading = true);
          _bloc.pauseAd(widget.ad).then((_) {
            _accountBloc.model.statistics.activeAdsCount--;
            _accountBloc.model.statistics.inactiveAdsCount++;
            _accountBloc.add(ProfileRefreshEvent());
            Fluttertoast.showToast(
              msg: AppLocalization.of(context).translate("paused"),
            );
          }).catchError((e) {
            showErrorBottomSheet(
                context, AppLocalization.of(context).translate("error"), "$e");
          }).whenComplete(() {
            setState(() => statusLoading = false);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => AdDetailsBloc(widget.ad.id),
                  child: AdDetailsLayout(),
                ),
              ),
            );
          },
          child: AdGallery(widget.ad),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: AdDetails(widget.ad),
        ),
        if (_accountBloc.model.id == widget.ad.owner.id)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              AppButton(
                child: Text(
                  AppLocalization.of(context).translate("edit"),
                  style: AppTextStyle.largeBlack,
                ),
                onTap: () {
                  Navigator.of(context)
                      .push(CupertinoPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => EditAdBloc(context, widget.ad),
                      child: EditAdLayout(),
                    ),
                  ))
                      .whenComplete(() {
                    setState(() {});
                  });
                },
              ),
              Builder(
                builder: (context) {
                  if (AdStatus.paused.name == widget.ad.status)
                    return AppButton(
                      child: statusLoading == true
                          ? CupertinoActivityIndicator()
                          : Text(
                              AppLocalization.of(context).translate("activate"),
                              style: AppTextStyle.largeBlack,
                            ),
                      onTap: statusLoading == true ? null : _activate,
                    );
                  if (AdStatus.active.name == widget.ad.status)
                    return AppButton(
                      child: statusLoading == true
                          ? CupertinoActivityIndicator()
                          : Text(
                              AppLocalization.of(context).translate("pause"),
                              style: AppTextStyle.largeBlack,
                            ),
                      onTap: statusLoading == true ? null : _pause,
                    );
                  return Text(
                    AppLocalization.of(context).translate("expired"),
                    style: AppTextStyle.mediumBlue,
                  );
                },
              ),
              AppButton(
                child: deleteLoading == true
                    ? CupertinoActivityIndicator()
                    : Text(
                        AppLocalization.of(context).translate("delete"),
                        style: AppTextStyle.largeBlack,
                      ),
                onTap: deleteLoading == true ? null : _delete,
              ),
            ],
          ),
        Divider(color: AppColors.deepGray),
      ],
    );
  }
}
