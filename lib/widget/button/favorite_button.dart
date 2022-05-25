import 'package:exservice/styles/app_colors.dart';
import 'package:flutter/material.dart';

class FavoriteButton extends StatelessWidget {
  final bool active;
  final VoidCallback onTap;

  const FavoriteButton({
    Key key,
    this.onTap,
    this.active = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Icon(
        active ? Icons.favorite : Icons.favorite_outline,
        size: 25,
        color: active ? AppColors.red : AppColors.gray,
      ),
    );
  }
}
