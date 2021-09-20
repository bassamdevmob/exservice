import 'package:exservice/renovation/bloc/view/favorites_bloc/favorites_cubit.dart';
import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/widget/application/reload_widget.dart';
import 'package:exservice/renovation/widget/bottom_sheets/error_bottom_sheet.dart';
import 'package:exservice/renovation/widget/cards/list_ad_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FavoritesLayout extends StatefulWidget {
  @override
  _FavoritesLayoutState createState() => _FavoritesLayoutState();
}

class _FavoritesLayoutState extends State<FavoritesLayout> {
  FavoritesCubit _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<FavoritesCubit>(context);
    _bloc.fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FavoritesCubit, FavoritesState>(
      listenWhen: (_, current) => current is FavoritesLazyErrorState,
      listener: (context, state) {
        if (state is FavoritesLazyErrorState) {
          showErrorBottomSheet(
            context,
            AppLocalization.of(context).trans("error"),
            state.message,
          );
        }
      },
      child: BlocBuilder<FavoritesCubit, FavoritesState>(
        buildWhen: (_, current) =>
            current is FavoritesAwaitState ||
            current is FavoritesErrorState ||
            current is FavoritesReceivedState,
        builder: (context, state) {
          if (state is FavoritesErrorState) {
            return Center(
              child: ReloadWidget.error(
                content: Text(state.message, textAlign: TextAlign.center),
                onPressed: () {
                  _bloc.fetch();
                },
              ),
            );
          } else if (state is FavoritesAwaitState) {
            return Center(child: CupertinoActivityIndicator());
          } else if (_bloc.adModels == null || _bloc.adModels.isEmpty) {
            return Center(
              child: ReloadWidget.empty(
                content: Text(
                  AppLocalization.of(context).trans("empty_data"),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                onPressed: () {
                  _bloc.fetch();
                },
              ),
            );
          }
          return SmartRefresher(
            enablePullUp: true,
            enablePullDown: true,
            footer: ClassicFooter(loadStyle: LoadStyle.ShowWhenLoading),
            onRefresh: () {
              return _bloc.fetchFirst();
            },
            onLoading: () {
              return _bloc.fetchNext();
            },
            controller: _bloc.refreshController,
            child: ListView.builder(
              itemCount: _bloc.adModels.length,
              itemBuilder: (context, index) {
                return ListAdCard(_bloc.adModels[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
