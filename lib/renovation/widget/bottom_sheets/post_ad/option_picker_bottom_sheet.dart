import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/utils/utils.dart';
import 'package:exservice/renovation/widget/application/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class OptionPickerBottomSheet<T> extends StatelessWidget {
  final String Function(T) textBuilder;
  final List<T> elements;

  static Future<T> show<T>(
    BuildContext context, {
    List<T> elements,
    String Function(T) textBuilder,
  }) {
    return showCupertinoModalBottomSheet<T>(
      expand: false,
      context: context,
      topRadius: Radius.circular(35),
      backgroundColor: Colors.transparent,
      builder: (context) => OptionPickerBottomSheet<T>(
        elements: elements,
        textBuilder: textBuilder,
      ),
    );
  }

  const OptionPickerBottomSheet({
    Key key,
    this.textBuilder,
    this.elements,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Material(
      child: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        shrinkWrap: true,
        children: [
          SizedBox(height: Utils.verticalSpace(mediaQuery)),
          LineBottomSheetWidget(),
          SizedBox(height: Utils.verticalSpace(mediaQuery)),
          Text(
            AppLocalization.of(context).trans("choose_option"),
            style: Theme.of(context).textTheme.headline3,
          ),
          SizedBox(height: Utils.verticalSpace(mediaQuery)),
          Material(
            child: Wrap(
              alignment: WrapAlignment.spaceAround,
              spacing: 10,
              children: [
                for (var element in elements)
                  InputChip(
                    label: Text(textBuilder(element)),
                    onPressed: () {
                      Navigator.of(context).pop(element);
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
