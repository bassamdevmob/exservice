import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/models/response/config_response.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/utils/sizer.dart';
import 'package:exservice/widget/application/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumericResult {
  final Unit unit;
  final num value;
  final String note;

  NumericResult({this.value, this.unit, this.note});
}

class NumericInputBottomSheet extends StatefulWidget {
  final String title;
  final NumericResult initValue;
  final List<Unit> unites;

  static Future<NumericResult> show(
    BuildContext context, {
    String title,
    NumericResult initValue,
    List<Unit> unites,
  }) {
    return showModalBottomSheet<NumericResult>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: Sizer.bottomSheetBorderRadius,
      ),
      builder: (context) => NumericInputBottomSheet(
        title: title,
        initValue: initValue,
        unites: unites,
      ),
    );
  }

  const NumericInputBottomSheet({
    Key key,
    this.title,
    this.initValue,
    this.unites,
  }) : super(key: key);

  @override
  State<NumericInputBottomSheet> createState() =>
      _NumericInputBottomSheetState();
}

class _NumericInputBottomSheetState extends State<NumericInputBottomSheet> {
  final TextEditingController valueController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  Unit unit;

  @override
  void initState() {
    if (widget.initValue != null) {
      valueController.text = widget.initValue.value.toString() ?? "0";
      noteController.text = widget.initValue.note;
      unit = widget.initValue.unit;
    }
    super.initState();
  }

  @override
  void dispose() {
    valueController.dispose();
    noteController.dispose();
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
        TextField(
          controller: valueController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          decoration: InputDecoration(
            labelText: AppLocalization.of(context).translate("amount"),
          ),
        ),
        SizedBox(height: Sizer.vs3),
        Wrap(
          alignment: WrapAlignment.spaceAround,
          spacing: 10,
          children: [
            for (var element in widget.unites)
              ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: Sizer.screenSize.width * 0.3,
                ),
                child: InputChip(
                  label: Text(element.value),
                  selected: unit == element,
                  selectedColor: AppColors.blueAccent,
                  onPressed: () {
                    setState(() {
                      unit = element;
                    });
                  },
                ),
              ),
          ],
        ),
        SizedBox(height: Sizer.vs3),
        TextField(
          controller: noteController,
          keyboardType: TextInputType.text,
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
                  if (valueController.text.isEmpty || unit == null) return;
                  Navigator.of(context).pop(NumericResult(
                    value: num.parse(valueController.text.trim()),
                    note: noteController.text.trim(),
                    unit: unit,
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
