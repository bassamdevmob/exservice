import 'package:exservice/models/response/chats_response.dart';
import 'package:exservice/utils/constant.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:exservice/utils/global.dart';
import 'package:exservice/widget/application/dotted_container.dart';
import 'package:exservice/widget/application/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';

class ChatCard extends StatelessWidget {
  final Chat chat;

  const ChatCard(this.chat, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final dimensions = width / 7;
    return ListTile(
      leading: OutlineContainer(
        strokeWidth: 1,
        radius: dimensions / 2,
        dimension: dimensions,
        gradient: LinearGradient(
          colors: [AppColors.blue, AppColors.deepPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        child: ClipOval(
          child: OctoImage(
            fit: BoxFit.cover,
            image: NetworkImage(chat.user.profilePicture),
            progressIndicatorBuilder: (context, _) => simpleShimmer,
            errorBuilder: (context, e, _) => Image.asset(
              PLACEHOLDER,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      title: Text(
        chat.user.username,
        style: AppTextStyle.largeBlackBold,
      ),
      subtitle: Text(
        chat.message.content,
        style: AppTextStyle.largeGray,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Builder(builder: (context) {
        final def = DateTime.now().difference(chat.message.date);
        if (def.inDays < 1) {
          return Text(
            jmTimeFormatter.format(chat.message.date),
            style: AppTextStyle.smallGray,
          );
        } else {
          return Text(
            dateFormatter.format(chat.message.date),
            style: AppTextStyle.smallGray,
          );
        }
      }),
    );
  }
}
