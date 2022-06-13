part of 'chat_bloc.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatAwaitState extends ChatState {}

class ChatAcceptState extends ChatState {
  final List<Message> messages;

  ChatAcceptState(this.messages);
}

class ChatErrorState extends ChatState {
  final dynamic error;

  ChatErrorState(this.error);
}
