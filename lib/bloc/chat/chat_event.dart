part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}

class ChatInitEvent extends ChatEvent {}

class ChatSinkEvent extends ChatEvent {
  final List<Message> messages;

  ChatSinkEvent(this.messages);
}

class ChatSendMessageEvent extends ChatEvent {}
