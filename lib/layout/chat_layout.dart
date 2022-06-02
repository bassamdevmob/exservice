import 'package:bubble/bubble.dart';
import 'package:exservice/bloc/chat/chat_bloc.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/models/response/chats_response.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/styles/app_font_size.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:exservice/utils/extensions.dart';
import 'package:exservice/utils/global.dart';
import 'package:exservice/widget/application/global_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octo_image/octo_image.dart';

class ChatLayout extends StatefulWidget {
  @override
  _ChatLayoutState createState() => _ChatLayoutState();
}

class _ChatLayoutState extends State<ChatLayout> {
  ChatBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<ChatBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.blue),
        title: Row(
          children: <Widget>[
            ClipOval(
              child: OctoImage(
                height: 40,
                width: 40,
                fit: BoxFit.cover,
                image: NetworkImage(_bloc.chatter.profilePicture),
                progressIndicatorBuilder: (context, _) => simpleShimmer,
                errorBuilder: (context, e, _) => Container(
                  color: AppColors.white,
                  child: Center(
                    child: Text(
                      _bloc.chatter.username.camelCase,
                      style: AppTextStyle.xxLargeBlack,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Text(
              _bloc.chatter.username,
              maxLines: 1,
              style: AppTextStyle.mediumBlue,
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: _bloc.chatStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }
                if (!snapshot.hasData) {
                  return Center(child: CupertinoActivityIndicator());
                }
                final messages = snapshot.data;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    BubbleNip bubbleNip;
                    final isNotFirst = index < messages.length - 1 &&
                        messages[index].senderId ==
                            messages[index + 1].senderId;
                    if (isNotFirst) {
                      bubbleNip = BubbleNip.no;
                    } else if (messages[index].senderId == _bloc.user.id) {
                      bubbleNip = BubbleNip.rightTop;
                    } else {
                      bubbleNip = BubbleNip.leftTop;
                    }
                    final textAlign = TextAlign.start;
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Align(
                        alignment: getAlignment(messages[index].senderId),
                        child: Bubble(
                          color: getColor(messages[index].senderId),
                          padding: BubbleEdges.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          nip: bubbleNip,
                          child: Builder(builder: (context) {
                            final message = getMessage(messages[index]);
                            if (isNotFirst) return message;
                            return Column(
                              crossAxisAlignment: getCrossAxisAlignment(
                                messages[index].senderId,
                              ),
                              children: <Widget>[
                                Text(
                                  "hello",
                                  style: AppTextStyle.largeGray,
                                  textAlign: textAlign,
                                ),
                                message
                              ],
                            );
                          }),
                        ),
                      ),
                    );
                  },
                  padding: EdgeInsets.all(8),
                );
              },
            ),
          ),
          getChatToolbar(),
        ],
      ),
    );
  }

  Alignment getAlignment(int senderId) =>
      senderId == _bloc.user.id ? Alignment.centerRight : Alignment.centerLeft;

  Color getColor(int senderId) =>
      senderId == _bloc.user.id ? AppColors.blue : AppColors.gray;

  CrossAxisAlignment getCrossAxisAlignment(int senderId) =>
      senderId == _bloc.user.id
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end;

  Widget getMessage(Message message) {
    final time = getTime(message.date);
    final content = getContent(message.content);
    final list = <Widget>[];
    if (message.senderId == _bloc.user.id) {
      list.add(content);
      list.add(time);
    } else {
      list.add(time);
      list.add(content);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: list,
    );
  }

  Widget getTime(DateTime date) {
    return Text(
      jmsTimeFormatter.format(date),
      style: AppTextStyle.xSmallAccentGray,
      textDirection: TextDirection.ltr,
    );
  }

  Widget getContent(String content) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.6,
      ),
      child: Text(
        content,
        maxLines: null,
        style: AppTextStyle.mediumWhite,
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget getChatToolbar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(100),
              // padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _bloc.controller,
                maxLines: 3,
                minLines: 1,
                style: AppTextStyle.mediumBlack,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 10,
                  ),
                  hintText:
                      AppLocalization.of(context).translate("type_message_hint"),
                  hintStyle: AppTextStyle.mediumGray,
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          InkWell(
            onTap: () {
              _bloc.add(ChatSendMessageEvent());
            },
            borderRadius: BorderRadius.circular(100),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.blue,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(10.0),
              child: Icon(
                Icons.send,
                color: AppColors.white,
                size: AppFontSize.large,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
