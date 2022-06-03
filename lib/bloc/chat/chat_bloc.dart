import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exservice/models/entity/user.dart';
import 'package:exservice/models/response/chats_response.dart';
import 'package:flutter/cupertino.dart';

part 'chat_event.dart';

part 'chat_state.dart';

const CHAT_COLLECTION = "chat";
const MESSAGE_COLLECTION = "messages";
const MESSAGE_COUNT_LIMIT = 50;

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final controller = TextEditingController();
  final User user;
  final User chatter;
  String _chatId;

  ChatBloc(this.user, this.chatter) : super(ChatInitial()) {
    _chatId = chatter.id > user.id
        ? "${chatter.id}-${user.id}"
        : "${user.id}-${chatter.id}";

    on((event, emit) async {
      if (event is ChatSendMessageEvent) {
        var message = controller.text.trim();
        if (message.isEmpty) return;
        sendMessage(Message(
          senderId: user.id,
          content: message,
          date: DateTime.now(),
        ));
        controller.clear();
      }
    });
  }

  @override
  Future<void> close() {
    controller.dispose();
    return super.close();
  }

  final _transformer = StreamTransformer<QuerySnapshot<Map<String, dynamic>>,
      List<Message>>.fromHandlers(
    handleData: (data, sink) {
      var messages = data.docs.map((e) {
        return Message.fromFirestoreJson(e.data());
      }).toList();
      sink.add(messages);
    },
  );

  Stream<List<Message>> get chatStream => FirebaseFirestore.instance
      .collection(CHAT_COLLECTION)
      .doc(_chatId)
      .collection(MESSAGE_COLLECTION)
      .orderBy('date', descending: true)
      .limit(MESSAGE_COUNT_LIMIT)
      .snapshots()
      .transform(_transformer);

  Future<DocumentReference> sendMessage(Message message) async {
    return FirebaseFirestore.instance
        .collection(CHAT_COLLECTION)
        .doc(_chatId)
        .collection(MESSAGE_COLLECTION)
        .add(message.toFirestoreJson());
  }
}
