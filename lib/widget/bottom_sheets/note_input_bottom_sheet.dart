import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/utils/sizer.dart';
import 'package:exservice/widget/application/global_widgets.dart';
import 'package:flutter/material.dart';

class NoteResult {
  final String note;

  NoteResult({this.note});
}

class NoteInputBottomSheet extends StatefulWidget {
  final NoteResult initValue;

  static Future<NoteResult> show(
    BuildContext context, {
    NoteResult initValue,
  }) {
    return showModalBottomSheet<NoteResult>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: Sizer.bottomSheetBorderRadius,
      ),
      builder: (context) => NoteInputBottomSheet(
        initValue: initValue,
      ),
    );
  }

  const NoteInputBottomSheet({
    Key key,
    this.initValue,
  }) : super(key: key);

  @override
  State<NoteInputBottomSheet> createState() => _NoteInputBottomSheetState();
}

class _NoteInputBottomSheetState extends State<NoteInputBottomSheet> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    if (widget.initValue != null) {
      controller.text = widget.initValue.note;
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
        SizedBox(height: Sizer.vs3),
        TextField(
          controller: controller,
          keyboardType: TextInputType.multiline,
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
                  if (controller.text.isEmpty) return;
                  Navigator.of(context).pop(NoteResult(
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
