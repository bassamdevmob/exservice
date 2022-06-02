import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/widget/application/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:exservice/utils/sizer.dart';

class DeleteBottomSheet extends StatelessWidget {
  final VoidCallback onTap;

  const DeleteBottomSheet({
    Key key,
    this.onTap,
  }) : super(key: key);

  static Future<T> show<T>(
    BuildContext context, {
    VoidCallback onTap,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: Sizer.bottomSheetBorderRadius,
      ),
      builder: (context) {
        return DeleteBottomSheet(
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
            AppLocalization.of(context).translate("delete_ad"),
            textAlign: TextAlign.start,
            style: Theme.of(context).primaryTextTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalization.of(context).translate("delete_ad_desc"),
            textAlign: TextAlign.start,
            style: Theme.of(context).primaryTextTheme.labelMedium,
          ),
          SizedBox(height: Sizer.vs1),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    AppLocalization.of(context).translate("cancel"),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              SizedBox(width: Sizer.hs2),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    AppLocalization.of(context).translate("next"),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    onTap();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
