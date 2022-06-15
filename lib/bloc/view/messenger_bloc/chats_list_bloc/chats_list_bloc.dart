
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:exservice/models/response/chats_response.dart';
import 'package:exservice/resources/repository/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

part 'chats_list_event.dart';

part 'chats_list_state.dart';

class ChatsListBloc extends Bloc<ChatsListEvent, ChatsListState> {
  List<Chat> models;

  ChatsListBloc() : super(ChatsListAwaitState()) {
    on((event, emit) async {
      if (event is ChatsListFetchEvent) {
        try {
          emit(ChatsListAwaitState());
          var response = await GetIt.I.get<UserRepository>().chats();
          models = response.data;
          emit(ChatsListAccessibleState());
        } on DioError catch (ex) {
          emit(ChatsListErrorState(ex.error));
        }
      }
    });
  }
}
