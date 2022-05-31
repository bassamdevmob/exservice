import 'package:exservice/bloc/view/favorites_bloc/favorites_cubit.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/utils/utils.dart';
import 'package:exservice/widget/application/reload_indicator.dart';
import 'package:exservice/widget/bottom_sheets/error_bottom_sheet.dart';
import 'package:exservice/widget/cards/ad_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BookmarksLayout extends StatefulWidget {
  @override
  _BookmarksLayoutState createState() => _BookmarksLayoutState();
}

class _BookmarksLayoutState extends State<BookmarksLayout> {
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
            title: AppLocalization.of(context).translate("error"),
            message: Utils.resolveErrorMessage(state.error),
          );
        }
      },
      child: BlocBuilder<FavoritesCubit, FavoritesState>(
        buildWhen: (_, current) =>
            current is FavoritesAwaitState ||
            current is FavoritesErrorState ||
            current is FavoritesAcceptState,
        builder: (context, state) {
          if (state is FavoritesAwaitState) {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          } else if (state is FavoritesErrorState) {
            return Center(
              child: ReloadIndicator(
                error: state.error,
                onTap: () {
                  _bloc.fetch();
                },
              ),
            );
          } else if (_bloc.models.isEmpty) {
            return Center(
              child: EmptyIndicator(
                onTap: () {
                  _bloc.fetch();
                },
              ),
            );
          }
          return SmartRefresher(
            controller: _bloc.controller,
            onRefresh: () => _bloc.refresh(),
            onLoading: () => _bloc.loadMore(),
            enablePullUp: _bloc.enablePullUp,
            enablePullDown: true,
            footer: ClassicFooter(
              onClick: () {
                if (_bloc.controller.footerStatus == LoadStatus.failed) {
                  _bloc.controller.requestLoading();
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
    );
  }
}
