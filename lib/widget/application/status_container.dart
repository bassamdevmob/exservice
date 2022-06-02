import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/utils/enums.dart';
import 'package:flutter/material.dart';

class StatusContainer extends StatelessWidget {
  final String status;

  const StatusContainer(this.status, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColors.blueAccent),
        color: AppColors.black.withOpacity(0.4),
      ),
      margin: EdgeInsets.all(10),
      child: Builder(
        builder: (context) {
          if (status == AdStatus.active.name)
            return Icon(Icons.play_arrow_rounded);
          if (status == AdStatus.paused.name)
            return Icon(Icons.pause_rounded);
          return Icon(Icons.timer_off_outlined);
        },
      ),
    );
  }
}
