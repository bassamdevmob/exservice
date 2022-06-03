import 'package:bubble/bubble.dart';
import 'package:exservice/bloc/chat/chat_bloc.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/models/response/chats_response.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:exservice/utils/extensions.dart';
import 'package:exservice/utils/global.dart';
import 'package:exservice/utils/sizer.dart';
import 'package:exservice/widget/application/global_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octo_image/octo_image.dart';
import 'package:intl/intl.dart' as intl;

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
        elevation: 5,
        title: Row(
          children: <Widget>[
            ClipOval(
              child: OctoImage(
                height: Sizer.avatarSizeSmall,
                width: Sizer.avatarSizeSmall,
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
              style: Theme.of(context).primaryTextTheme.titleLarge,
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
                  return Center(
                    child: CupertinoActivityIndicator(),
                  );
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
                    var owned = messages[index].senderId == _bloc.user.id;
                    if (isNotFirst) {
                      bubbleNip = BubbleNip.no;
                    } else if (owned) {
                      bubbleNip = BubbleNip.rightTop;
                    } else {
                      bubbleNip = BubbleNip.leftTop;
                    }
                    return Padding(
                      padding: EdgeInsetsDirectional.only(
                        top: isNotFirst ? 3 : 10,
                        bottom: 2,
                        start: owned ? Sizer.hs1 : (isNotFirst ? 10: 0),
                        end: owned ? (isNotFirst ? 10: 0) : Sizer.hs1,
                      ),
                      child: Align(
                        alignment: getAlignment(messages[index].senderId),
                        child: Bubble(
                          nipHeight: 12,
                          nipWidth: 10,
                          radius: Radius.circular(15),
                          color: getColor(messages[index].senderId),
                          nip: bubbleNip,
                          padding: BubbleEdges.symmetric(
                            horizontal: Sizer.vs3,
                          ),
                          child: getMessage(messages[index]),
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
      senderId == _bloc.user.id ? AppColors.blue : Colors.grey[800];

  CrossAxisAlignment getCrossAxisAlignment(int senderId) =>
      senderId == _bloc.user.id
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end;

  Widget getMessage(Message message) {
    var direction = intl.Bidi.estimateDirectionOfText(message.content);
    return Wrap(
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.end,
      children: [
        Text(
          message.content,
          maxLines: null,
          style: AppTextStyle.mediumWhite,
          textAlign: direction == intl.TextDirection.LTR
              ? TextAlign.start
              : TextAlign.end,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            jmTimeFormatter.format(message.date),
            style: AppTextStyle.xSmallAccentGray,
            textDirection: TextDirection.ltr,
          ),
        ),
      ],
    );
  }

  Widget getChatToolbar() {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
    );
    return Padding(
      padding: EdgeInsets.only(bottom: Sizer.vs1, left: 10, right: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: TextFormField(
              controller: _bloc.controller,
              maxLines: 3,
              minLines: 1,
              style: AppTextStyle.mediumBlack,
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).colorScheme.onSecondary,
                border: border,
                enabledBorder: border,
                focusedBorder: border,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 10,
                ),
                hintText: AppLocalization.of(context).translate("message"),
                hintStyle: Theme.of(context).primaryTextTheme.labelSmall,
              ),
            ),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              _bloc.add(ChatSendMessageEvent());
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.blue,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(12.0),
              child: Icon(
                Icons.send,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
