import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:exservice/renovation/bloc/view/account_bloc/account_bloc.dart';
import 'package:exservice/renovation/bloc/view/favorites_bloc/favorites_cubit.dart';
import 'package:exservice/renovation/bloc/view/home_bloc/home_bloc.dart';
import 'package:exservice/renovation/bloc/view/messenger_bloc/chats_list_bloc/chats_list_bloc.dart';
import 'package:exservice/renovation/bloc/view/messenger_bloc/notifications_list_bloc/notification_list_bloc.dart';
import 'package:exservice/renovation/bloc/view/post_ad_bloc/post_ad_bloc.dart';
import 'package:exservice/renovation/layout/drawer_layout.dart';
import 'package:exservice/renovation/layout/view/account_layout.dart';
import 'package:exservice/renovation/layout/view/favorites_layout.dart';
import 'package:exservice/renovation/layout/view/home_layout.dart';
import 'package:exservice/renovation/layout/view/messenger_layout.dart';
import 'package:exservice/renovation/layout/view/post_ad_layout.dart';
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
    BlocProvider(
      create: (context) => PostAdBloc(),
      child: PostAdLayout(),
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
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: AppColors.white,
        color: AppColors.blue,
        activeColor: AppColors.blue,
        style: TabStyle.textIn,
        items: [
          TabItem(
            icon: Icon(Icons.home, color: AppColors.gray),
            activeIcon: Icon(Icons.home, color: AppColors.blue),
            title: AppLocalization.of(context).trans('home'),
          ),
          TabItem(
            icon: Icon(Icons.favorite_border, color: AppColors.gray),
            activeIcon: Icon(Icons.favorite_border, color: AppColors.blue),
            title: AppLocalization.of(context).trans('favorite'),
          ),
          TabItem(
            icon: Icon(Icons.add, color: AppColors.gray),
            activeIcon: Icon(Icons.add, color: AppColors.blue),
            title: AppLocalization.of(context).trans('post'),
          ),
          TabItem(
            icon: Icon(Icons.mail_outline, color: AppColors.gray),
            activeIcon: Icon(Icons.mail_outline, color: AppColors.blue),
            title: AppLocalization.of(context).trans('message'),
          ),
          TabItem(
            icon: Icon(Icons.person_outline, color: AppColors.gray),
            activeIcon: Icon(Icons.person_outline, color: AppColors.blue),
            title: AppLocalization.of(context).trans('account'),
          ),
        ],
        initialActiveIndex: _index,
        onTap: (int i) {
          setState(() {
            _index = i;
          });
        },
      ),
    );
  }
}
