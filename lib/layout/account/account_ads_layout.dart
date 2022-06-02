import 'package:exservice/bloc/account/account_ads_bloc/account_ads_cubit.dart';
import 'package:exservice/bloc/ad_details_bloc/ad_details_bloc.dart';
import 'package:exservice/layout/ad_details_layout.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/utils/enums.dart';
import 'package:exservice/utils/sizer.dart';
import 'package:exservice/utils/utils.dart';
import 'package:exservice/widget/application/ad_details.dart';
import 'package:exservice/widget/application/ad_media.dart';
import 'package:exservice/widget/application/reload_indicator.dart';
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
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kTextTabBarHeight),
            child: BlocBuilder<AccountAdsCubit, AccountAdsState>(
              buildWhen: (_, current) => current is AccountAdsChangeStatusState,
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      child: Icon(Icons.play_arrow_rounded),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: _bloc.types.contains(AdStatus.active)
                            ? AppColors.blueAccent
                            : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        _bloc.select(AdStatus.active);
                      },
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: _bloc.types.contains(AdStatus.paused)
                            ? AppColors.blueAccent
                            : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Icon(Icons.pause_rounded),
                      onPressed: () {
                        _bloc.select(AdStatus.paused);
                      },
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: _bloc.types.contains(AdStatus.expired)
                            ? AppColors.blueAccent
                            : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Icon(Icons.timer_off_outlined),
                      onPressed: () {
                        _bloc.select(AdStatus.expired);
                      },
                    ),
                  ],
                );
              },
            ),
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
                padding: EdgeInsets.symmetric(vertical: Sizer.vs2),
                itemCount: _bloc.models.length,
                itemBuilder: (context, index) {
                  var model = _bloc.models[index];
                  return  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => AdDetailsBloc(model.id),
                                child: AdDetailsLayout(),
                              ),
                            ),
                          );
                        },
                        child: AdGallery(model),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: Sizer.vs3,
                          horizontal: Sizer.vs3,
                        ),
                        child: AdDetails(model),
                      ),
                      Divider(color: AppColors.deepGray),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
