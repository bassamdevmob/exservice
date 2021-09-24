import 'package:exservice/helper/AppConstant.dart';
import 'package:exservice/models/GetChatUsersModel.dart';
import 'package:exservice/renovation/styles/app_colors.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:exservice/renovation/utils/global.dart';
import 'package:exservice/renovation/widget/application/dotted_container.dart';
import 'package:exservice/widget/component/AppShimmers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';

class ChatCard extends StatelessWidget {
  final Chatter chatter;

  const ChatCard(this.chatter, {Key key}) : super(key: key);

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
            image: NetworkImage(chatter.user.profilePic),
            progressIndicatorBuilder: (context, _) => CustomShimmer.normal(),
            errorBuilder: (context, e, _) => Image.asset(
              AppConstant.placeholder,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      title: Text(
        chatter.user.name,
        style: AppTextStyle.largeBlackBold,
      ),
      subtitle: Text(
        chatter.message.content,
        style: AppTextStyle.largeGray,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Builder(builder: (context) {
        final date = DateTime.fromMillisecondsSinceEpoch(
          chatter.message.timestamp,
        );
        final def = DateTime.now().difference(date);
        if (def.inDays < 1) {
          return Text(
            jmTimeFormatter.format(date),
            style: AppTextStyle.smallGray,
          );
        } else {
          return Text(
            dateFormatter.format(date),
            style: AppTextStyle.smallGray,
          );
        }
      }),
    );
  }
}
