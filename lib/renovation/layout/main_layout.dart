import 'package:exservice/renovation/bloc/view/account_bloc/account_bloc.dart';
import 'package:exservice/renovation/bloc/view/favorites_bloc/favorites_cubit.dart';
import 'package:exservice/renovation/bloc/view/home_bloc/home_bloc.dart';
import 'package:exservice/renovation/bloc/view/messenger_bloc/chats_list_bloc/chats_list_bloc.dart';
import 'package:exservice/renovation/bloc/view/messenger_bloc/notifications_list_bloc/notification_list_bloc.dart';
import 'package:exservice/renovation/bloc/view/post_ad_bloc/post_ad_bloc.dart';
import 'package:exservice/renovation/layout/drawer_layout.dart';
import 'package:exservice/renovation/layout/post/post_ad_layout.dart';
import 'package:exservice/renovation/layout/view/account_layout.dart';
import 'package:exservice/renovation/layout/view/favorites_layout.dart';
import 'package:exservice/renovation/layout/view/home_layout.dart';
import 'package:exservice/renovation/layout/view/messenger_layout.dart';
import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/styles/app_colors.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
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
    context.read<AccountBloc>().add(AccountFetchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: AppColors.white,
        centerTitle: true,
        title: Text(
          AppLocalization.of(context).trans('app_name'),
          style: AppTextStyle.largeBlack,
        ),
        actions: [
          IconButton(
            icon: Icon(
              CupertinoIcons.list_bullet_indent,
              color: AppColors.blue,
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
            label: AppLocalization.of(context).trans('home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border, color: AppColors.gray),
            activeIcon: Icon(Icons.favorite_border, color: AppColors.blue),
            label: AppLocalization.of(context).trans('favorite'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add, color: AppColors.gray),
            activeIcon: Icon(Icons.add, color: AppColors.blue),
            label: AppLocalization.of(context).trans('post'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail_outline, color: AppColors.gray),
            activeIcon: Icon(Icons.mail_outline, color: AppColors.blue),
            label: AppLocalization.of(context).trans('message'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, color: AppColors.gray),
            activeIcon: Icon(Icons.person_outline, color: AppColors.blue),
            label: AppLocalization.of(context).trans('account'),
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
