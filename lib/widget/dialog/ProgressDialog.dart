import 'package:exservice/renovation/styles/app_colors.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

const kFromByteToMega = 1024 * 1024;
Widget _progressWidget = Image.asset(
  'assets/images/double_ring_loading.gif',
);

class ProgressProperty {
  double progress;
  double maxProgress;
  bool showProgress;
  String title;
  String details;

  ProgressProperty(this.title,
      {this.details = "Loading...",
      this.showProgress = false,
      this.progress = 0,
      this.maxProgress = 0.0});
}

class ProgressDialogModel {
  bool isShowing = false;
  String message = "Loading...";
  List<ProgressProperty> data;

  ProgressDialogModel({this.message, this.data});
}

class CustomProgressDialog extends StatelessWidget {
  final ProgressDialogModel _model;

  CustomProgressDialog(this._model);

  @override
  Widget build(BuildContext context) {
    final loader = Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 60.0,
        height: 60.0,
        child: _progressWidget,
      ),
    );

    final title = Text(
      _model.message,
      style: AppTextStyle.largeBlack,
    );

    final main = Row(
      children: <Widget>[
        loader,
        title,
      ],
    );

    if (_model.data == null || _model.data.isEmpty) {
      return main;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        main,
        Divider(),
        ListView.separated(
          shrinkWrap: true,
          itemCount: _model.data.length,
          itemBuilder: (context, index) {
            var children = <Widget>[
              Text(
                _model.data[index].title,
                style: AppTextStyle.largeBlack,
              ),
              Text(
                _model.data[index].details,
                style: AppTextStyle.mediumGray,
              ),
            ];
            if (_model.data[index].showProgress) {
              children.add(SizedBox(
                height: 10,
              ));
              children.add(LinearPercentIndicator(
                // width: MediaQuery.of(context).size.width - 50,
                animateFromLastPercent: true,
                animation: true,
                lineHeight: 15.0,
                percent: _model.data[index].progress /
                    _model.data[index].maxProgress,
                center: Text(
                  "${_model.data[index].progress.toStringAsFixed(1)}M/${_model.data[index].maxProgress.toStringAsFixed(1)}M",
                  style: AppTextStyle.smallWhite,
                ),
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: AppColors.deepPurple,
              ));
            }
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: children,
              ),
            );
          },
          separatorBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Divider(
              color: AppColors.gray,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}
