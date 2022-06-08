import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:flutter/material.dart';

class ExtraNotesLayout extends StatefulWidget {
  const ExtraNotesLayout({Key key}) : super(key: key);

  @override
  State<ExtraNotesLayout> createState() => _ExtraNotesLayoutState();
}

class _ExtraNotesLayoutState extends State<ExtraNotesLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
      appBar: AppBar(
        actions: [
          Center(
            child: getNextButton(),
          ),
        ],
      ),
    );
  }

  Widget getNextButton() {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          AppLocalization.of(context).translate("next"),
          style: AppTextStyle.largeBlue,
        ),
      ),
      onTap: () {},
    );
  }
}
