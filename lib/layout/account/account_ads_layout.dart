import 'package:exservice/bloc/account/account_ads_bloc/account_ads_cubit.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:exservice/widget/application/reload_widget.dart';
import 'package:exservice/widget/application/user_ad.dart';
import 'package:exservice/widget/bottom_sheets/error_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AccountAdsLayout extends StatefulWidget {
  @override
  _AccountAdsLayoutState createState() => _AccountAdsLayoutState();
}

class _AccountAdsLayoutState extends State<AccountAdsLayout> {
  AccountAdsCubit _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<AccountAdsCubit>(context);
    _bloc.fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountAdsCubit, AccountAdsState>(
      listenWhen: (_, current) => current is AccountAdsLazyErrorState,
      listener: (context, state) {
        if (state is AccountAdsLazyErrorState) {
          showErrorBottomSheet(
            context,
            AppLocalization.of(context).translate("error"),
            state.message,
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
        body: BlocBuilder<AccountAdsCubit, AccountAdsState>(
          buildWhen: (_, current) =>
              current is AccountAdsErrorState ||
              current is AccountAdsAwaitState ||
              current is AccountAdsReceivedState,
          builder: (context, state) {
            if (state is AccountAdsErrorState) {
              return Center(
                child: ReloadWidget.error(
                  content: Text(state.message, textAlign: TextAlign.center),
                  onPressed: () {
                    _bloc.fetch();
                  },
                ),
              );
            }
            if (state is AccountAdsAwaitState) {
              return Center(child: CupertinoActivityIndicator());
            }
            if (_bloc.models == null || _bloc.models.isEmpty)
              return Center(
                child: ReloadWidget.empty(
                  content: Text(
                    AppLocalization.of(context).translate("empty_data"),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  onPressed: () {
                    _bloc.fetch();
                  },
                ),
              );
            return SmartRefresher(
              enablePullUp: true,
              enablePullDown: true,
              onRefresh: () {
                return _bloc.fetchFirst();
              },
              onLoading: () {
                return _bloc.fetchNext();
              },
              footer: ClassicFooter(loadStyle: LoadStyle.ShowWhenLoading),
              controller: _bloc.refreshController,
              child: ListView.builder(
                itemCount: _bloc.models.length,
                itemBuilder: (context, index) {
                  return UserAd(_bloc.models[index]);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
