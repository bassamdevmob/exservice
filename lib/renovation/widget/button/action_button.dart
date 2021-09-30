import 'package:flutter/material.dart';
import 'package:exservice/renovation/styles/app_colors.dart';
import 'package:exservice/renovation/utils/utils.dart';

class ActionButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function() onTap;

  const ActionButton(
    this.title,
    this.subtitle,
    this.onTap, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline6,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context)
            .textTheme
            .bodyText2
            .copyWith(color: AppColors.gray),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_outlined,
        size: Utils.iconSize(mediaQuery),
        color: AppColors.blue,
      ),
      onTap: onTap,
    );
  }
}
