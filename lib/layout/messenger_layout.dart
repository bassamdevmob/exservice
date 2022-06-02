import 'package:exservice/bloc/chat/chat_bloc.dart';
import 'package:exservice/bloc/profile_bloc/profile_bloc.dart';
import 'package:exservice/bloc/view/messenger_bloc/chats_list_bloc/chats_list_bloc.dart';
import 'package:exservice/layout/chat_layout.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:exservice/utils/global.dart';
import 'package:exservice/utils/sizer.dart';
import 'package:exservice/widget/application/global_widgets.dart';
import 'package:exservice/widget/application/reload_indicator.dart';
import 'package:exservice/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octo_image/octo_image.dart';

class MessengerLayout extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MessengerLayoutState();
}

class MessengerLayoutState extends State<MessengerLayout> {
  ChatsListBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<ChatsListBloc>(context);
    _bloc.add(ChatsListFetchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalization.of(context).translate("chats"),
        ),
      ),
      body: BlocBuilder<ChatsListBloc, ChatsListState>(
        buildWhen: (_, current) =>
            current is ChatsListErrorState ||
            current is ChatsListAwaitState ||
            current is ChatsListAccessibleState,
        builder: (context, state) {
          if (state is ChatsListAwaitState) {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }
          if (state is ChatsListErrorState) {
            return Center(
              child: ReloadIndicator(
                error: state.error,
                onTap: () {
                  _bloc.add(ChatsListFetchEvent());
                },
              ),
            );
          }
          if (_bloc.models.isEmpty) {
            return Center(
              child: EmptyIndicator(
                onTap: () {
                  _bloc.add(ChatsListFetchEvent());
                },
              ),
            );
          }
          return ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: Sizer.hs3),
            itemCount: _bloc.models.length,
            separatorBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(
                left: Sizer.avatarSizeLarge,
                right: Sizer.hs3,
              ),
              child: Divider(color: AppColors.gray, height: 1),
            ),
            itemBuilder: (context, index) {
              var model = _bloc.models[index];
              return ListTile(
                onTap: () {
                  Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => ChatBloc(
                        BlocProvider.of<ProfileBloc>(context).model,
                        _bloc.models[index].user,
                      ),
                      child: ChatLayout(),
                    ),
                  ));
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
                  model.message.content,
                  style: Theme.of(context).primaryTextTheme.labelMedium,
                  maxLines: 1,
                ),
                contentPadding: EdgeInsets.zero,
                trailing: Builder(builder: (context) {
                  final date = model.message.date;
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
          );
        },
      ),
    );
  }
}
