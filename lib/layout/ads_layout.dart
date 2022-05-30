import 'package:exservice/bloc/ads_bloc/ads_cubit.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/utils/utils.dart';
import 'package:exservice/widget/application/reload_indicator.dart';
import 'package:exservice/widget/bottom_sheets/error_bottom_sheet.dart';
import 'package:exservice/widget/cards/ad_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AdsLayout extends StatefulWidget {
  @override
  _AdsLayoutState createState() => _AdsLayoutState();
}

class _AdsLayoutState extends State<AdsLayout> {
  AdsCubit _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<AdsCubit>(context);
    _bloc.fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdsCubit, AdsState>(
      listenWhen: (_, current) => current is AdsLazyErrorState,
      listener: (context, state) {
        if (state is AdsLazyErrorState) {
          showErrorBottomSheet(
            context,
            AppLocalization.of(context).translate("error"),
            Utils.resolveErrorMessage(state.error),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: BlocBuilder<AdsCubit, AdsState>(
          buildWhen: (_, current) =>
              current is AdsAwaitState ||
              current is AdsAcceptState ||
              current is AdsErrorState,
          builder: (context, state) {
            if (state is AdsAwaitState) {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            }
            if (state is AdsErrorState) {
              return Center(
                child: ReloadIndicator(
                  error: state.error,
                  onTap: () {
                    _bloc.fetch();
                  },
                ),
              );
            }
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
                  return AdCard(_bloc.models[index]);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
