part of 'chats_list_bloc.dart';

@immutable
abstract class ChatsListEvent {}

class ChatsListFetchEvent implements ChatsListEvent {}

class ChatsListFilterEvent implements ChatsListEvent {
  final String substring;

  ChatsListFilterEvent(this.substring);
}
