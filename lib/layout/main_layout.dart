import 'package:exservice/bloc/profile_bloc/profile_bloc.dart';
import 'package:exservice/bloc/view/favorites_bloc/favorites_cubit.dart';
import 'package:exservice/bloc/view/home_bloc/home_bloc.dart';
import 'package:exservice/bloc/view/messenger_bloc/chats_list_bloc/chats_list_bloc.dart';
import 'package:exservice/bloc/view/messenger_bloc/notifications_list_bloc/notification_list_bloc.dart';
import 'package:exservice/bloc/view/post_ad_bloc/post_ad_bloc.dart';
import 'package:exservice/layout/drawer_layout.dart';
import 'package:exservice/layout/post/post_ad_layout.dart';
import 'package:exservice/layout/view/account_layout.dart';
import 'package:exservice/layout/view/favorites_layout.dart';
import 'package:exservice/layout/view/home_layout.dart';
import 'package:exservice/layout/view/messenger_layout.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainLayout extends StatefulWidget {
  static const route = "/main";

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
      child: FavoritesLayout(),
    ),
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ChatsListBloc()),
        BlocProvider(create: (context) => NotificationListBloc()),
      ],
      child: MessengerLayout(),
    ),
    AccountLayout(),
  ];

  int _index = 0;

  @override
  void initState() {
    context.read<ProfileBloc>().add(ProfileFetchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalization.of(context).translate('app_name'),
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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.blue,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: AppColors.gray),
            activeIcon: Icon(Icons.home, color: AppColors.blue),
            label: AppLocalization.of(context).translate('home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border, color: AppColors.gray),
            activeIcon: Icon(Icons.favorite_border, color: AppColors.blue),
            label: AppLocalization.of(context).translate('favorite'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add, color: AppColors.gray),
            activeIcon: Icon(Icons.add, color: AppColors.blue),
            label: AppLocalization.of(context).translate('post'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail_outline, color: AppColors.gray),
            activeIcon: Icon(Icons.mail_outline, color: AppColors.blue),
            label: AppLocalization.of(context).translate('message'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, color: AppColors.gray),
            activeIcon: Icon(Icons.person_outline, color: AppColors.blue),
            label: AppLocalization.of(context).translate('account'),
          ),
        ],
        currentIndex: _index,
        onTap: (int i) {
          if (i == 2) {
            Navigator.of(context).push(CupertinoPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => PostAdBloc(),
                child: PostAdLayout(),
              ),
            ));
          } else if(i > 2){
            setState(() {
              _index = i - 1;
            });
          }
        },
      ),
    );
  }
}
