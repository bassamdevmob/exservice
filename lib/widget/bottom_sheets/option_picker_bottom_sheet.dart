import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/models/response/config_response.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/utils/sizer.dart';
import 'package:exservice/widget/application/global_widgets.dart';
import 'package:flutter/material.dart';

class OptionResult {
  final Option option;
  final String note;

  OptionResult({this.option, this.note});
}

class OptionPickerBottomSheet extends StatefulWidget {
  final String title;
  final OptionResult selected;
  final List<Option> elements;

  static Future<OptionResult> show(
    BuildContext context, {
    String title,
    OptionResult selected,
    List<Option> elements,
  }) {
    return showModalBottomSheet<OptionResult>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: Sizer.bottomSheetBorderRadius,
      ),
      builder: (context) => OptionPickerBottomSheet(
        title: title,
        selected: selected,
        elements: elements,
      ),
    );
  }

  const OptionPickerBottomSheet({
    Key key,
    this.title,
    this.selected,
    this.elements,
  }) : super(key: key);

  @override
  State<OptionPickerBottomSheet> createState() =>
      _OptionPickerBottomSheetState();
}

class _OptionPickerBottomSheetState extends State<OptionPickerBottomSheet> {
  final TextEditingController controller = TextEditingController();
  Option selected;

  @override
  void initState() {
    if (widget.selected != null) {
      selected = widget.selected.option;
      controller.text = widget.selected.note;
    }
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: Sizer.bottomSheetPadding.add(
        MediaQuery.of(context).viewInsets,
      ),
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
                  label: Text(element.text),
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
        TextField(
          controller: controller,
          keyboardType: TextInputType.text,
          maxLines: null,
          decoration: InputDecoration(
            labelText: AppLocalization.of(context).translate("note"),
          ),
        ),
        SizedBox(height: Sizer.vs1),
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
                  if (selected == null) return;
                  Navigator.of(context).pop(OptionResult(
                    option: selected,
                    note: controller.text.trim(),
                  ));
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
