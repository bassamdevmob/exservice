import 'package:exservice/renovation/styles/app_colors.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AppInputFieldBorder { outlineInputBorder, UnderlineInputBorder }

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboard;
  final bool secured;
  final bool isFirst;
  final FocusNode next;
  final FocusNode focusNode;
  final Widget prefix;
  final List<TextInputFormatter> inputFormatters;
  final bool readOnly;
  final Widget suffix;
  final TextDirection textDirection;
  final FormFieldValidator<String> validator;
  final Color borderColor;
  final Color focusColor;
  final Color errorColor;
  final Color backgroundColor;
  final VoidCallback onTap;
  final EdgeInsetsGeometry padding;
  final int maxLines;
  final int maxLength;
  final String hint;
  final String errorText;
  final String label;
  final TextStyle style;
  final TextStyle bioStyle;
  final AppInputFieldBorder borderType;

  AppTextField({
    Key key,
    this.controller,
    this.keyboard = TextInputType.text,
    this.secured = false,
    this.next,
    this.focusNode,
    this.prefix,
    this.inputFormatters,
    this.readOnly = false,
    this.suffix,
    this.onTap,
    this.validator,
    this.borderColor = AppColors.gray,
    this.style,
    this.focusColor = AppColors.gray,
    this.isFirst = false,
    this.errorColor = AppColors.gray,
    this.hint,
    this.bioStyle,
    this.backgroundColor = AppColors.grayAccent,
    this.maxLines,
    this.maxLength,
    this.textDirection = TextDirection.ltr,
    this.padding,
    this.label,
    this.borderType = AppInputFieldBorder.outlineInputBorder,
    this.errorText,
  }) : super(key: key);

  _getBorder(Color color) {
    if (AppInputFieldBorder.outlineInputBorder == borderType) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: color,
        ),
      );
    } else {
      return UnderlineInputBorder(
        borderSide: BorderSide(
          color: color,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final _style = style ?? AppTextStyle.largeBlack;
    final _bioStyle = bioStyle ?? AppTextStyle.largeGray;
    Widget _input = TextFormField(
      autofocus: false,
      focusNode: focusNode,
      onEditingComplete: () {
        if (next != null)
          FocusScope.of(context).requestFocus(next);
        else
          FocusScope.of(context).unfocus();
      },
      onTap: onTap,
      readOnly: readOnly,
      obscureText: secured,
//      textAlign: TextAlign.start,
      keyboardType: keyboard,
      controller: controller,
      cursorColor: AppColors.gray,
      style: _style,
      textDirection: textDirection,
      maxLines: maxLines,
      validator: validator,
      maxLength: maxLength,
//      maxLengthEnforced: false,
      decoration: InputDecoration(
        errorText: errorText,
        prefixIcon: prefix,
        hintText: hint,
        hintStyle: _bioStyle,
        labelText: label,
        labelStyle: _bioStyle,
        fillColor: AppColors.gray,
        contentPadding: padding,
        border: _getBorder(borderColor),
        focusedBorder: _getBorder(focusColor),
        enabledBorder: _getBorder(borderColor),
        errorMaxLines: 2,
        errorStyle: AppTextStyle.mediumRed,
        errorBorder: _getBorder(errorColor),
        focusedErrorBorder: _getBorder(errorColor),
        suffixIcon: suffix,
      ),
      inputFormatters: inputFormatters,
    );
    return AppInputFieldBorder.outlineInputBorder == borderType
        ? Container(color: backgroundColor, child: _input)
        : _input;
  }
}
