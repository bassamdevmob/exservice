import 'package:flutter/material.dart';
import 'package:exservice/renovation/styles/app_colors.dart';
import 'package:exservice/renovation/utils/utils.dart';

class LineBottomSheetWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: Utils.passwordValidatorWidth(MediaQuery.of(context)),
        height: 6,
        decoration: BoxDecoration(
          color: AppColors.lightGray.withOpacity(0.18),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}