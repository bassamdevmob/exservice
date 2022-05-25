import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:exservice/models/response/chats_response.dart';
import 'package:exservice/resources/repository/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

part 'chats_list_event.dart';

part 'chats_list_state.dart';

class ChatsListBloc extends Bloc<ChatsListEvent, ChatsListState> {
  String filterChatterName;
  List<Chat> _chats;
  List<Chat> chats;
  final controller = TextEditingController();

  void _filterListener() {
    add(ChatsListFilterEvent(controller.text.trim()));
  }

  ChatsListBloc() : super(ChatsListAwaitState()) {
    controller.addListener(_filterListener);
    on((event, emit) async {
      if (event is ChatsListFetchEvent) {
        try {
          emit(ChatsListAwaitState());
          var response =
              await GetIt.I.get<UserRepository>().chats();
          _chats = response.data;
          chats = List.of(_chats);
          emit(ChatsListAccessibleState());
        } catch (e) {
          emit(ChatsListErrorState("$e"));
        }
      } else if (event is ChatsListFilterEvent) {
        filterChatterName = event.substring;
        var filteredChatter = _chats.where(
          (chatter) => chatter.user.username.contains(
            RegExp(filterChatterName, caseSensitive: false),
          ),
        );
        chats = List.of(filteredChatter);
        emit(ChatsListAccessibleState());
      }
    });
  }

  @override
  Future<void> close() {
    controller.dispose();
    return super.close();
  }
}
