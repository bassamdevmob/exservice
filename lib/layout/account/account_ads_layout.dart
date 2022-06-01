import 'package:exservice/bloc/account/account_ads_bloc/account_ads_cubit.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/utils/utils.dart';
import 'package:exservice/widget/application/reload_indicator.dart';
import 'package:exservice/widget/application/user_ad.dart';
import 'package:exservice/widget/bottom_sheets/error_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AccountAdsLayout extends StatefulWidget {
  const AccountAdsLayout({Key key}) : super(key: key);

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
            title: AppLocalization.of(context).translate("error"),
            message: Utils.resolveErrorMessage(state.error),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalization.of(context).translate('listings'),
          ),
        ),
        body: BlocBuilder<AccountAdsCubit, AccountAdsState>(
          buildWhen: (_, current) =>
              current is AccountAdsErrorState ||
              current is AccountAdsAwaitState ||
              current is AccountAdsAcceptState,
          builder: (context, state) {
            if (state is AccountAdsAwaitState) {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            }
            if (state is AccountAdsErrorState) {
              return Center(
                child: ReloadIndicator(
                  error: state.error,
                  onTap: () {
                    _bloc.fetch();
                  },
                ),
              );
            }
            if (_bloc.models.isEmpty)
              return Center(
                child: EmptyIndicator(
                  onTap: () {
                    _bloc.fetch();
                  },
                ),
              );
            return SmartRefresher(
              controller: _bloc.refreshController,
              onRefresh: () => _bloc.refresh(),
              onLoading: () => _bloc.loadMore(),
              enablePullUp: _bloc.enablePullUp,
              enablePullDown: true,
              footer: ClassicFooter(
                onClick: () {
                  if (_bloc.refreshController.footerStatus ==
                      LoadStatus.failed) {
                    _bloc.refreshController.requestLoading();
                  }
                },
              ),
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
