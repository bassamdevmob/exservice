import 'package:exservice/renovation/bloc/chat/chat_bloc.dart';
import 'package:exservice/renovation/bloc/view/account_bloc/account_bloc.dart';
import 'package:exservice/renovation/bloc/view/messenger_bloc/chats_list_bloc/chats_list_bloc.dart';
import 'package:exservice/renovation/layout/chat/chat_layout.dart';
import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/styles/app_colors.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:exservice/renovation/widget/application/reload_widget.dart';
import 'package:exservice/renovation/widget/application/separated_sliver_child_builder_delegate.dart';
import 'package:exservice/renovation/widget/cards/chat_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatsListLayout extends StatefulWidget {
  @override
  State<ChatsListLayout> createState() => _ChatsListLayoutState();
}

class _ChatsListLayoutState extends State<ChatsListLayout> {
  ChatsListBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<ChatsListBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatsListBloc, ChatsListState>(
      buildWhen: (_, current) =>
          current is ChatsListErrorState ||
          current is ChatsListAwaitState ||
          current is ChatsListAccessibleState,
      builder: (context, state) {
        if (state is ChatsListErrorState) {
          return Center(
            child: ReloadWidget.error(
              content: Text(state.message, textAlign: TextAlign.center),
              onPressed: () {
                _bloc.add(ChatsListFetchEvent());
              },
            ),
          );
        }
        if (state is ChatsListAwaitState) {
          return Center(child: CupertinoActivityIndicator());
        }

        return CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
              sliver: SliverToBoxAdapter(
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(10),
                  child: TextField(
                    controller: _bloc.chatterNameFilterController,
                    maxLines: 1,
                    autofocus: false,
                    style: AppTextStyle.mediumBlack,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                      hintText:
                          "${AppLocalization.of(context).trans("search")}...",
                      hintStyle: AppTextStyle.mediumGray,
                      suffixIcon: GestureDetector(
                        child: Icon(Icons.clear, color: AppColors.blue),
                        onTap: () {
                          _bloc.chatterNameFilterController.clear();
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (_bloc.chatters == null || _bloc.chatters.isEmpty)
              SliverToBoxAdapter(
                child: ReloadWidget.empty(
                  content: Text(
                    AppLocalization.of(context).trans("empty_data"),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  onPressed: () {
                    _bloc.add(ChatsListFetchEvent());
                  },
                ),
              )
            else
              SliverList(
                delegate: SeparatedSliverChildBuilderDelegate(
                  childCount: _bloc.chatters.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      child: ChatCard(_bloc.chatters[index]),
                      onTap: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => ChatBloc(
                              BlocProvider.of<AccountBloc>(context)
                                  .profile
                                  .user,
                              _bloc.chatters[index].user,
                            ),
                            child: ChatLayout(),
                          ),
                        ));
                      },
                    );
                  },
                  separatorBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(left: 70, right: 20),
                    child: Divider(color: AppColors.gray, height: 1),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
