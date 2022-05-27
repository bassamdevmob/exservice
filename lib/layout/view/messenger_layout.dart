import 'package:exservice/bloc/view/messenger_bloc/chats_list_bloc/chats_list_bloc.dart';
import 'package:exservice/bloc/view/messenger_bloc/notifications_list_bloc/notification_list_bloc.dart';
import 'package:exservice/layout/chat/chats_list_layout.dart';
import 'package:exservice/layout/chat/notifications_layout.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessengerLayout extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MessengerLayoutState();
}

class MessengerLayoutState extends State<MessengerLayout> {
  @override
  void initState() {
    BlocProvider.of<ChatsListBloc>(context).add(ChatsListFetchEvent());
    BlocProvider.of<NotificationListBloc>(context)
        .add(FetchNotificationListEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: <Widget>[
          TabBar(
            indicatorColor: AppColors.blue,
            tabs: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  AppLocalization.of(context).translate("chats"),
                  style: AppTextStyle.largeBlue,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  AppLocalization.of(context).translate("notifications"),
                  style: AppTextStyle.largeBlue,
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: <Widget>[
                ChatsListLayout(),
                NotificationsLayout(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
