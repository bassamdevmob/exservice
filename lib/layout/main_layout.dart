import 'package:exservice/bloc/post/composition_repository.dart';
import 'package:exservice/bloc/post/media_picker_bloc/compose_media_picker_bloc.dart';
import 'package:exservice/bloc/view/favorites_bloc/favorites_cubit.dart';
import 'package:exservice/bloc/view/home_bloc/home_bloc.dart';
import 'package:exservice/bloc/view/messenger_bloc/chats_list_bloc/chats_list_bloc.dart';
import 'package:exservice/bloc/view/messenger_bloc/notifications_bloc/notifications_cubit.dart';
import 'package:exservice/controller/data_store.dart';
import 'package:exservice/layout/drawer_layout.dart';
import 'package:exservice/layout/messenger_layout.dart';
import 'package:exservice/layout/compose/compose_media_picker_layout.dart';
import 'package:exservice/layout/view/account_layout.dart';
import 'package:exservice/layout/view/bookmarks_layout.dart';
import 'package:exservice/layout/view/home_layout.dart';
import 'package:exservice/layout/view/notifications_layout.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/utils/sizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainLayout extends StatefulWidget {
  static const route = "/main";

  const MainLayout({Key key}) : super(key: key);

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final _views = [
    BlocProvider(
      create: (context) => HomeBloc(),
      child: HomeLayout(),
    ),
    BlocProvider(
      create: (context) => FavoritesCubit(),
      child: BookmarksLayout(),
    ),
    SizedBox(),
    BlocProvider(
      create: (context) => NotificationsCubit(),
      child: NotificationsLayout(),
    ),
    AccountLayout(),
  ];

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: !DataStore.instance.hasToken
            ? null
            : IconButton(
                splashRadius: 25,
                icon: Icon(CupertinoIcons.chat_bubble_text),
                onPressed: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => ChatsListBloc(),
                        child: MessengerLayout(),
                      ),
                    ),
                  );
                },
              ),
        centerTitle: true,
        title: Image.asset(
          "assets/images/app_icon.png",
          width: Sizer.avatarSizeSmall,
        ),
        actions: [
          IconButton(
            icon: Icon(
              CupertinoIcons.list_bullet_indent,
            ),
            onPressed: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => DrawerLayout(),
                ),
              );
            },
          ),
        ],
      ),
      body: _views[_index],
      bottomNavigationBar: !DataStore.instance.hasToken
          ? null
          : BottomNavigationBar(
              backgroundColor: AppColors.white,
              selectedItemColor: AppColors.blue,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined, color: AppColors.gray),
                  activeIcon: Icon(Icons.home, color: AppColors.blue),
                  label: AppLocalization.of(context).translate('home'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bookmark_outline, color: AppColors.gray),
                  activeIcon: Icon(Icons.bookmark, color: AppColors.blue),
                  label: AppLocalization.of(context).translate('marks'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add, color: AppColors.gray),
                  activeIcon: Icon(Icons.add, color: AppColors.blue),
                  label: AppLocalization.of(context).translate('post'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.mail_outline, color: AppColors.gray),
                  activeIcon: Icon(Icons.mail, color: AppColors.blue),
                  label: AppLocalization.of(context).translate('notifications'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline, color: AppColors.gray),
                  activeIcon: Icon(Icons.person, color: AppColors.blue),
                  label: AppLocalization.of(context).translate('account'),
                ),
              ],
              currentIndex: _index,
              onTap: (int i) {
                if (i == 2) {
                  Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => ComposeMediaPickerBloc(
                        CompositionRepository(),
                      ),
                      child: ComposeMediaPickerLayout(),
                    ),
                  ));
                } else {
                  setState(() {
                    _index = i;
                  });
                }
              },
            ),
    );
  }
}
