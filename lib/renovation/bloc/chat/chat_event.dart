part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}

class ChatSendMessageEvent extends ChatEvent {}
