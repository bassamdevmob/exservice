import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/utils/sizer.dart';
import 'package:exservice/widget/application/global_widgets.dart';
import 'package:flutter/material.dart';

typedef TextBuilder<T> = String Function(T);

class OptionPickerBottomSheet<T> extends StatefulWidget {
  final String title;
  final T selected;
  final List<T> elements;
  final TextBuilder<T> elementTextBuilder;

  static Future<T> show<T>(
    BuildContext context, {
    String title,
    T selected,
    List<T> elements,
    TextBuilder<T> elementTextBuilder,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: Sizer.bottomSheetBorderRadius,
      ),
      builder: (context) => OptionPickerBottomSheet<T>(
        title: title,
        selected: selected,
        elements: elements,
        elementTextBuilder: elementTextBuilder,
      ),
    );
  }

  const OptionPickerBottomSheet({
    Key key,
    this.title,
    this.selected,
    this.elements,
    this.elementTextBuilder,
  }) : super(key: key);

  @override
  State<OptionPickerBottomSheet<T>> createState() =>
      _OptionPickerBottomSheetState<T>();
}

class _OptionPickerBottomSheetState<T>
    extends State<OptionPickerBottomSheet<T>> {
  T selected;

  @override
  void initState() {
    selected = widget.selected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: Sizer.bottomSheetPadding,
      shrinkWrap: true,
      children: [
        SizedBox(height: Sizer.vs2),
        Center(child: BottomSheetStroke()),
        SizedBox(height: Sizer.vs2),
        Text(
          widget.title,
          style: Theme.of(context).primaryTextTheme.titleLarge,
        ),
        SizedBox(height: Sizer.vs2),
        Wrap(
          alignment: WrapAlignment.spaceAround,
          spacing: 10,
          children: [
            for (var element in widget.elements)
              ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: Sizer.screenSize.width * 0.3,
                ),
                child: InputChip(
                  label: Text(widget.elementTextBuilder(element)),
                  selected: selected == element,
                  selectedColor: AppColors.blueAccent,
                  onPressed: () {
                    setState(() {
                      selected = element;
                    });
                  },
                ),
              ),
          ],
        ),
        SizedBox(height: Sizer.vs3),
        Row(
          children: [
            Expanded(
              child: TextButton(
                style: TextButton.styleFrom(
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
                  Navigator.of(context).pop(selected);
                },
              ),
            ),
          ],
        ),
        SizedBox(height: Sizer.vs3),
      ],
    );
  }
}
