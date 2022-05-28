import 'package:exservice/widget/application/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:exservice/utils/sizer.dart';

class ActionBottomSheet extends StatelessWidget {
  final String title;
  final String subtitle;
  final String confirmText;
  final VoidCallback onTap;

  const ActionBottomSheet({
    Key key,
    this.title,
    this.subtitle,
    this.confirmText,
    this.onTap,
  }) : super(key: key);

  static Future<T> show<T>(
    BuildContext context, {
    String title,
    String subtitle,
    String confirmText,
    VoidCallback onTap,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: Sizer.bottomSheetBorderRadius,
      ),
      builder: (context) {
        return ActionBottomSheet(
          title: title,
          subtitle: subtitle,
          confirmText: confirmText,
          onTap: onTap,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Sizer.bottomSheetPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(child: BottomSheetStroke()),
          SizedBox(height: Sizer.vs2),
          Text(
            title,
            textAlign: TextAlign.start,
            style: Theme.of(context).primaryTextTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.start,
            style: Theme.of(context).primaryTextTheme.labelMedium,
          ),
          SizedBox(height: Sizer.vs1),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: ElevatedButton(
              onPressed: onTap,
              child: Text(confirmText),
            ),
          ),
        ],
      ),
    );
  }
}
