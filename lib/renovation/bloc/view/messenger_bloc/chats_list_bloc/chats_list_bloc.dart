import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:exservice/models/GetChatUsersModel.dart';
import 'package:exservice/resources/api/ApiProviderDelegate.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'chats_list_event.dart';
part 'chats_list_state.dart';

class ChatsListBloc extends Bloc<ChatsListEvent, ChatsListState> {
  String filterChatterName;
  List<Chatter> _chatters;
  List<Chatter> chatters;
  final chatterNameFilterController = TextEditingController();

  void _filterListener() {
    add(ChatsListFilterEvent(chatterNameFilterController.text.trim()));
  }

  ChatsListBloc() : super(ChatsListAwaitState()) {
    chatterNameFilterController.addListener(_filterListener);
  }

  @override
  Future<void> close() {
    chatterNameFilterController.dispose();
    return super.close();
  }

  @override
  Stream<ChatsListState> mapEventToState(
    ChatsListEvent event,
  ) async* {
    if (event is ChatsListFetchEvent) {
      try {
        yield ChatsListAwaitState();
        var response =
            await GetIt.I.get<ApiProviderDelegate>().fetchGetChatUsers();
        _chatters = response;
        chatters = List.of(_chatters);
        yield ChatsListReceiveState();
      } catch (e) {
        yield ChatsListErrorState("$e");
      }
    } else if (event is ChatsListFilterEvent) {
      filterChatterName = event.substring;
      var filteredChatter = _chatters.where(
        (chatter) => chatter.user.name.contains(
          RegExp(filterChatterName, caseSensitive: false),
        ),
      );
      chatters = List.of(filteredChatter);
      yield ChatsListReceiveState();
    }
  }
}
