import 'package:exservice/renovation/bloc/default/ad_details_bloc/ad_details_bloc.dart';
import 'package:exservice/renovation/bloc/view/messenger_bloc/notifications_list_bloc/notification_list_bloc.dart';
import 'package:exservice/renovation/layout/ad_details_layout.dart';
import 'package:exservice/renovation/styles/app_colors.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:exservice/renovation/utils/extensions.dart';
import 'package:exservice/renovation/utils/global.dart';
import 'package:exservice/renovation/widget/application/dotted_container.dart';
import 'package:exservice/renovation/widget/application/global_widgets.dart';
import 'package:exservice/renovation/widget/application/reload_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octo_image/octo_image.dart';

class NotificationsLayout extends StatefulWidget {
  @override
  State<NotificationsLayout> createState() => _NotificationsLayoutState();
}

class _NotificationsLayoutState extends State<NotificationsLayout> {
  NotificationListBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<NotificationListBloc>(context);
    _bloc.add(FetchNotificationListEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final dimensions = width / 7;

    return BlocBuilder<NotificationListBloc, NotificationListState>(
      builder: (context, state) {
        if (state is NotificationListErrorState) {
          return Center(
            child: ReloadWidget.error(
              content: Text(state.message, textAlign: TextAlign.center),
              onPressed: () {
                _bloc.add(FetchNotificationListEvent());
              },
            ),
          );
        }
        if (state is NotificationListAwaitState) {
          return Center(child: CupertinoActivityIndicator());
        }
        return ListView.separated(
          itemCount: _bloc.notes.length,
          itemBuilder: (context, index) {
            var model = _bloc.notes[index];
            return ListTile(
              enabled: true,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => AdDetailsBloc(_bloc.notes[index].id),
                    child: AdDetailsLayout(),
                  ),
                ));
              },
              leading: OutlineContainer(
                dimension: dimensions,
                gradient: LinearGradient(
                  colors: [AppColors.blue, AppColors.deepPurple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                radius: dimensions / 2,
                strokeWidth: 1,
                child: ClipOval(
                  child: OctoImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(model.ad.owner.profilePic),
                    progressIndicatorBuilder: (context, progress) =>
                        simpleShimmer,
                    errorBuilder: (context, error, stacktrace) => Container(
                      color: AppColors.grayAccent,
                      child: Center(
                        child: Text(
                          model.ad.owner.name.camelCase,
                          style: AppTextStyle.xxLargeBlack,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              title: Text(
                model.ad.owner.companyName ?? model.ad.owner.name,
                style: AppTextStyle.largeBlackBold,
              ),
              subtitle: Text(
                "${model.ad.attr.option.title}, ${model.ad.attr.category.title}",
                style: AppTextStyle.largeGray,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Builder(builder: (context) {
                final date = model.createdAt;
                final def = DateTime.now().difference(date);
                if (def.inDays < 1) {
                  return Text(
                    jmTimeFormatter.format(date),
                    style: AppTextStyle.smallGray,
                  );
                } else {
                  return Text(
                    dateFormatter.format(date),
                    style: AppTextStyle.smallGray,
                  );
                }
              }),
            );
          },
          separatorBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(left: 70, right: 20),
            child: Divider(
              color: AppColors.gray,
              height: 1,
            ),
          ),
        );
      },
    );
  }
}
