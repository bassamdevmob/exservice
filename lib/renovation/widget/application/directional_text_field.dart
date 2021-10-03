import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class DirectionalTextField extends StatefulWidget {
  final FocusNode focusNode;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final InputDecoration decoration;

  const DirectionalTextField({
    Key key,
    this.focusNode,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.decoration,
  }) : super(key: key);

  @override
  _DirectionalTextFieldState createState() => _DirectionalTextFieldState();
}

class _DirectionalTextFieldState extends State<DirectionalTextField> {
  TextDirection _direction;

  @override
  void initState() {
    if (widget.controller.text.isNotEmpty) {
      var isLTR = intl.Bidi.startsWithLtr(widget.controller.text);
      _direction = isLTR ? TextDirection.ltr : TextDirection.rtl;
    } else {
      _direction = TextDirection.ltr;
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
    var isLTR = intl.Bidi.startsWithLtr(widget.controller.text);
    if (_direction == TextDirection.rtl && isLTR) {
      setState(() => _direction = TextDirection.ltr);
    } else if (_direction == TextDirection.ltr && !isLTR) {
      setState(() => _direction = TextDirection.rtl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: widget.focusNode,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      decoration: widget.decoration,
      textDirection: _direction,
    );
  }
}
