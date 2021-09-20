import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/styles/app_colors.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:exservice/renovation/widget/button/app_button.dart';
import 'package:exservice/widget/application/AppTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

final abs = RegExp(r"^[1-9][0-9]*$");
final zeros = RegExp(r"^[0]*");

class NumberFormatter extends TextInputFormatter {
  final double maxValue;
  final TextEditingController min;
  final TextEditingController max;

  NumberFormatter({this.min, this.max, this.maxValue});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // try {
    int position = newValue.selection.baseOffset;
    String _text = newValue.text;
    // _text = _text.replaceAll(',', '');
    // int commas = newValue.text.length - _text.length;
    _text = _text.replaceAll(zeros, '');
    position -= newValue.text.length - _text.length;
    if (_text.isEmpty) {
      _text = "0";
      position = 1;
    } else if (!abs.hasMatch(_text) ||
        (min != null && double.parse(min.text) > double.parse(_text)) ||
        (max != null && double.parse(max.text) < double.parse(_text)) ||
        (maxValue != null && maxValue < double.parse(_text))) {
      return TextEditingValue(
        text: oldValue.text,
        selection: oldValue.selection,
      );
    }

    // position += commas;
    return TextEditingValue(
      text: _text,
      selection: TextSelection.fromPosition(TextPosition(offset: position)),
    );
    // }catch(e){
    //   print(e);
    // }
  }
//
// String _applyMask(String mask, String value) {
//   String result = '';
//
//   int maskCharIndex = mask.length - 1;
//   int valueCharIndex = mask.length - 1;
//
//   while (true) {
//     // if mask is ended, break.
//     if (maskCharIndex < 0) {
//       break;
//     }
//
//     // if value is ended, break.
//     if (valueCharIndex < 0) {
//       break;
//     }
//
//     final String maskChar = mask[maskCharIndex];
//     final String valueChar = value[valueCharIndex];
//
//     // value equals mask, just set
//     if (maskChar == valueChar) {
//       result += maskChar;
//       valueCharIndex += 1;
//       maskCharIndex += 1;
//       continue;
//     }
//
//     // apply translator if match
//     if (translator.containsKey(maskChar)) {
//       if (translator[maskChar].hasMatch(valueChar)) {
//         result += valueChar;
//         maskCharIndex += 1;
//       }
//
//       valueCharIndex += 1;
//       continue;
//     }
//
//     // not masked value, fixed char on mask
//     result += maskChar;
//     maskCharIndex += 1;
//     continue;
//   }
//
//   return result;
// }
}

class EditRangeDialog extends StatefulWidget {
  final int min;
  final int max;
  final double maxValue;

  const EditRangeDialog(this.min, this.max, this.maxValue, {Key key})
      : super(key: key);

  @override
  _EditRangeDialogState createState() => _EditRangeDialogState();
}

class _EditRangeDialogState extends State<EditRangeDialog> {
  TextEditingController _min;
  TextEditingController _max;
  final formatCurrency = new NumberFormat.decimalPattern();

  @override
  void initState() {
    // _min = MaskedTextController(mask: '000.000.000');
    _min = TextEditingController(text: widget.min.toString());
    _max = TextEditingController(text: widget.max.toString());
    super.initState();
  }

  @override
  void dispose() {
    _min.dispose();
    _max.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            AppLocalization.of(context).trans("acceptedRange"),
            style: AppTextStyle.largeBlue,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                "${formatCurrency.format(0)}  -  ${formatCurrency.format(widget.maxValue)}"),
          ),
          AppTextField(
            label: AppLocalization.of(context).trans("min"),
            keyboard: TextInputType.number,
            backgroundColor: AppColors.transparent,
            borderType: AppInputFieldBorder.outlineInputBorder,
            controller: _min,
            padding: EdgeInsets.symmetric(horizontal: 5),
            bioStyle: AppTextStyle.mediumGray,
            style: AppTextStyle.mediumBlack,
            focusColor: AppColors.gray,
            borderColor: AppColors.gray,
            maxLines: 1,
            suffix: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text("£"),
            ),
            inputFormatters: <TextInputFormatter>[
              NumberFormatter(max: _max)
            ], // Only nu
          ),
          SizedBox(height: 20),
          AppTextField(
            label: AppLocalization.of(context).trans("max"),
            keyboard: TextInputType.number,
            backgroundColor: AppColors.transparent,
            borderType: AppInputFieldBorder.outlineInputBorder,
            controller: _max,
            padding: EdgeInsets.symmetric(horizontal: 5),
            bioStyle: AppTextStyle.mediumGray,
            style: AppTextStyle.mediumBlack,
            focusColor: AppColors.gray,
            borderColor: AppColors.gray,
            maxLines: 1,
            suffix: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text("£"),
            ),
            // errorText: snapshot.data,
            inputFormatters: <TextInputFormatter>[
              NumberFormatter(min: _min, maxValue: widget.maxValue)
            ], // Only nu
          ),
          SizedBox(height: 20),
          AppButton(
            child: Text(
              AppLocalization.of(context).trans("ok"),
              style: AppTextStyle.largeBlack,
            ),
            onTap: () {
              Navigator.of(context).pop(
                RangeValues(
                  int.parse(_min.text) / widget.maxValue,
                  int.parse(_max.text) / widget.maxValue,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
