import 'package:exservice/bloc/ads_list_bloc/ads_list_cubit.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:exservice/utils/enums.dart';
import 'package:exservice/widget/application/reload_widget.dart';
import 'package:exservice/widget/bottom_sheets/error_bottom_sheet.dart';
import 'package:exservice/widget/cards/grid_ad_card.dart';
import 'package:exservice/widget/cards/list_ad_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AdsListLayout extends StatefulWidget {
  @override
  _AdsListLayoutState createState() => _AdsListLayoutState();
}

class _AdsListLayoutState extends State<AdsListLayout> {
  AdsListCubit _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<AdsListCubit>(context);
    _bloc.fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdsListCubit, AdsListState>(
      listenWhen: (_, current) => current is AdsListLazyErrorState,
      listener: (context, state) {
        if (state is AdsListLazyErrorState) {
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
        body: BlocBuilder<AdsListCubit, AdsListState>(
          buildWhen: (_, current) =>
              current is AdsListAwaitState ||
              current is AdsListReceivedState ||
              current is AdsListErrorState,
          builder: (context, state) {
            if (state is AdsListErrorState) {
              return Center(
                child: ReloadWidget.error(
                  content: Text(state.message, textAlign: TextAlign.center),
                  onPressed: () {
                    _bloc.fetch();
                  },
                ),
              );
            }
            if (state is AdsListAwaitState) {
              return Center(child: CupertinoActivityIndicator());
            }
            return Column(
              children: [
                getTabs(),
                Expanded(
                  child: SmartRefresher(
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
                    child: BlocBuilder<AdsListCubit, AdsListState>(
                      buildWhen: (_, current) =>
                          current is AdsListChangeFormatState,
                      builder: (context, state) {
                        switch (_bloc.format) {
                          case DisplayFormat.grid:
                            return GridView.count(
                              shrinkWrap: true,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 10,
                              crossAxisCount: 2,
                              padding: EdgeInsets.only(
                                  right: 5, left: 5, bottom: 10),
                              childAspectRatio: (4 / 7),
                              scrollDirection: Axis.vertical,
                              children: List.generate(
                                _bloc.models.length,
                                (index) {
                                  return GridAdCard(_bloc.models[index]);
                                },
                              ),
                            );
                          default:
                            return ListView.builder(
                              itemCount: _bloc.models.length,
                              itemBuilder: (context, index) {
                                return ListAdCard(_bloc.models[index]);
                              },
                            );
                        }
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget getTabs() {
    return BlocBuilder<AdsListCubit, AdsListState>(
      buildWhen: (_, current) => current is AdsListChangeFormatState,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  if (_bloc.format == DisplayFormat.list) return;
                  _bloc.changeFormat(DisplayFormat.list);
                },
                child: Icon(
                  Icons.view_day,
                  color: _bloc.format == DisplayFormat.list
                      ? AppColors.blue
                      : AppColors.deepGray,
                ),
              ),
              InkWell(
                onTap: () {
                  if (_bloc.format == DisplayFormat.grid) return;
                  _bloc.changeFormat(DisplayFormat.grid);
                },
                child: Icon(
                  Icons.dashboard,
                  color: _bloc.format == DisplayFormat.grid
                      ? AppColors.blue
                      : AppColors.deepGray,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
