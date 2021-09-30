import 'package:flutter/material.dart';

class Application {
  final GlobalKey<NavigatorState> globalKey = GlobalKey();

  static final Application instance = Application._internal();

  Application._internal();

  BuildContext get context => globalKey.currentContext;
}
