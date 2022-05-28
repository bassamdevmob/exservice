import 'package:exservice/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;

class DirectionalTextField extends StatefulWidget {
  final int maxLines;
  final FocusNode focusNode;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final InputDecoration decoration;
  final List<TextInputFormatter> inputFormatters;

  const DirectionalTextField({
    Key key,
    this.controller,
    this.focusNode,
    this.maxLines,
    this.keyboardType,
    this.obscureText = false,
    this.decoration,
    this.inputFormatters,
  }) : super(key: key);

  @override
  _DirectionalTextFieldState createState() => _DirectionalTextFieldState();
}

class _DirectionalTextFieldState extends State<DirectionalTextField>{
  TextDirection _direction;

  @override
  void initState() {
    var direction = intl.Bidi.estimateDirectionOfText(widget.controller.text);
    switch (direction) {
      case intl.TextDirection.RTL:
        _direction = TextDirection.rtl;
        break;
      case intl.TextDirection.LTR:
        _direction = TextDirection.ltr;
        break;
      default:
        _direction = Directionality.of(navigatorKey.currentContext);
    }
    widget.controller.addListener(_listener);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);
    super.dispose();
  }

  void _listener() {
    if (!mounted) return;
    var direction = intl.Bidi.estimateDirectionOfText(widget.controller.text);
    if (direction == intl.TextDirection.UNKNOWN) {
      setState(() => Directionality.of(context));
    } else if (_direction == TextDirection.rtl && direction == intl.TextDirection.LTR) {
      setState(() => _direction = TextDirection.ltr);
    } else if (_direction == TextDirection.ltr &&
        direction == intl.TextDirection.RTL) {
      setState(() => _direction = TextDirection.rtl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: widget.maxLines,
      focusNode: widget.focusNode,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      decoration: widget.decoration,
      inputFormatters: widget.inputFormatters,
      textDirection: _direction,
    );
  }
}
