part of 'chats_list_bloc.dart';

@immutable
abstract class ChatsListState {}

class ChatsListAwaitState extends ChatsListState {}

class ChatsListAccessibleState extends ChatsListState {}

class ChatsListErrorState extends ChatsListState {
  final String message;

  ChatsListErrorState(this.message);
}
