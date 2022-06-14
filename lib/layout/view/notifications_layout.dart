import 'package:exservice/bloc/ad_details_bloc/ad_details_bloc.dart';
import 'package:exservice/bloc/view/messenger_bloc/notifications_bloc/notifications_cubit.dart';
import 'package:exservice/layout/ad_details_layout.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:exservice/utils/global.dart';
import 'package:exservice/utils/sizer.dart';
import 'package:exservice/utils/extensions.dart';
import 'package:exservice/widget/application/global_widgets.dart';
import 'package:exservice/widget/application/reload_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octo_image/octo_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NotificationsLayout extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NotificationsLayoutState();
}

class NotificationsLayoutState extends State<NotificationsLayout> {
  NotificationsCubit _bloc;

  @override
  void initState() {
    _bloc = context.read<NotificationsCubit>();
    _bloc.fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        if (state is NotificationsAwaitState) {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        }
        if (state is NotificationsErrorState) {
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
              if (_bloc.refreshController.footerStatus == LoadStatus.failed) {
                _bloc.refreshController.requestLoading();
              }
            },
          ),
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: Sizer.hs3),
            itemCount: _bloc.models.length,
            itemBuilder: (context, index) {
              var model = _bloc.models[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => AdDetailsBloc(
                          _bloc.models[index].ad.id,
                          locator: context.read,
                        ),
                        child: AdDetailsLayout(),
                      ),
                    ),
                  );
                },
                leading: ClipOval(
                  child: OctoImage(
                    height: Sizer.avatarSizeLarge,
                    width: Sizer.avatarSizeLarge,
                    fit: BoxFit.cover,
                    image: NetworkImage(model.user.profilePicture),
                    progressIndicatorBuilder: (ctx, _) => simpleShimmer,
                    errorBuilder: (ctx, error, _) => Container(
                      alignment: Alignment.center,
                      color: AppColors.grayAccent,
                      child: Text(
                        model.user.username.firstCapLetter,
                        style: AppTextStyle.xxLargeBlack,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  model.user.username,
                  style: Theme.of(context).primaryTextTheme.bodyLarge,
                ),
                subtitle: Text(
                  model.ad.title,
                  style: Theme.of(context).primaryTextTheme.labelMedium,
                ),
                trailing: Builder(builder: (context) {
                  final date = model.date;
                  final def = DateTime.now().difference(date);
                  if (def.inDays < 1) {
                    return Text(
                      jmTimeFormatter.format(date),
                      style: Theme.of(context).primaryTextTheme.labelSmall,
                    );
                  } else {
                    return Text(
                      dateFormatter.format(date),
                      style: Theme.of(context).primaryTextTheme.labelSmall,
                    );
                  }
                }),
              );
            },
            separatorBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(
                left: Sizer.avatarSizeLarge,
                right: Sizer.hs3,
              ),
              child: Divider(
                color: AppColors.gray,
                height: 1,
              ),
            ),
          ),
        );
      },
    );
  }
}
