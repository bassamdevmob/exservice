import 'dart:async';
import 'dart:math';

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
  final User me;
  final User peer;
  DocumentReference _conversationRef;
  StreamSubscription _subscription;

  ChatBloc(this.me, this.peer) : super(ChatAwaitState()) {
    var id = "${min(peer.id, me.id)}-${max(peer.id, me.id)}";
    _conversationRef =
        FirebaseFirestore.instance.collection(CHAT_COLLECTION).doc(id);

    on<ChatInitEvent>((event, emit) async {
      try {
        emit(ChatAwaitState());
        var doc = await _conversationRef.get();
        if (!doc.exists) {
          await _conversationRef.set({
            "peers": [peer.id, me.id]
          });
        }
        on<ChatSendMessageEvent>((event, emit) async {
          var message = controller.text.trim();
          if (message.isEmpty) return;
          sendMessage(Message(
            senderId: me.id,
            content: message,
            date: DateTime.now(),
          ));
          controller.clear();
        });
        _subscription = chatStream.listen((event) => add(ChatSinkEvent(event)));
      } catch (ex) {
        emit(ChatErrorState(ex));
      }
    });

    on<ChatSinkEvent>((event, emit) async {
      emit(ChatAcceptState(event.messages));
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
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

  Stream<List<Message>> get chatStream => _conversationRef
      .collection(MESSAGE_COLLECTION)
      .orderBy('date', descending: true)
      .limit(MESSAGE_COUNT_LIMIT)
      .snapshots()
      .transform(_transformer);

  Future<DocumentReference> sendMessage(Message message) async {
    return _conversationRef
        .collection(MESSAGE_COLLECTION)
        .add(message.toFirestoreJson());
  }
}
