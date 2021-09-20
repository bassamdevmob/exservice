import 'package:exservice/bloc/StatePusher.dart';
import 'package:exservice/helper/AppConstant.dart';
import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/styles/app_colors.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:exservice/resources/AccountManager.dart';
import 'package:exservice/resources/api/ApiProviderDelegate.dart';
import 'package:exservice/widget/application/AppTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';

class CompleteAccountUpdate extends StatefulWidget {
  final String account;
  final int type;

  const CompleteAccountUpdate(this.account, this.type, {Key key})
      : super(key: key);

  @override
  _CompleteAccountUpdateState createState() => _CompleteAccountUpdateState();
}

class _CompleteAccountUpdateState extends State<CompleteAccountUpdate> {
  final _controller = TextEditingController();
  final _pusher = StatePusher<Null>.publish();

  // Timer _timer;
  // int _multi = 1;
  // int _start = 1;

  bool _loading = false;
  bool _isValid = false;

  void listener() {
    _isValid = _controller.text.length >= 6;
    _pusher.push();
  }

  @override
  void initState() {
    _controller.addListener(listener);
    super.initState();
  }

  @override
  void dispose() {
    // _timer?.cancel();
    _controller.removeListener(listener);
    _controller.dispose();
    _pusher.dispose();
    super.dispose();
  }

  void verifyAccount() {
    _loading = true;
    _pusher.push();
    GetIt.I.get<ApiProviderDelegate>()
      ..fetchCompleteUpdateEmailPhone(
              context, _controller.text, widget.account, widget.type)
          .then((_) {
        if (widget.type == AppConstant.emailCode) {
          GetIt.I.get<AccountManager>().profile.user.email = widget.account;
        } else {
          GetIt.I.get<AccountManager>().profile.user.phoneNumber =
              widget.account;
        }
        Fluttertoast.showToast(
            msg: AppLocalization.of(context).trans("edited"));
        Navigator.of(context).pop();
      }).catchError((err) {
        _loading = false;
        _pusher.push();
        _controller.text = '';
        Fluttertoast.showToast(msg: err.toString());
      });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final viewInsets = MediaQuery.of(context).viewInsets;
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: height - viewInsets.bottom,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Center(
                    child: Text(
                      AppLocalization.of(context)
                          .trans('enter_confirmation_code'),
                      style: AppTextStyle.xLargeBlackBold,
                    ),
                  ),
                  SizedBox(height: 20),
                  AppTextField(
                    controller: _controller,
                    keyboard: TextInputType.number,
                    padding: EdgeInsets.only(left: 20, top: 5, bottom: 5),
                    hint:
                        AppLocalization.of(context).trans('confirmation_code'),
                    bioStyle: AppTextStyle.mediumGray,
                    style: AppTextStyle.mediumBlack,
                    focusColor: AppColors.gray,
                    borderColor: AppColors.gray,
                    backgroundColor: AppColors.transparent,
                    maxLength: 6,
                    maxLines: 1,
                  ),
                  SizedBox(height: 5),
                  StreamBuilder<Null>(
                    stream: _pusher.stream,
                    builder: (context, snapshot) {
                      return RaisedButton(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: _loading
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CupertinoActivityIndicator(),
                                )
                              : Text(
                                  AppLocalization.of(context).trans('next'),
                                  style: AppTextStyle.mediumWhite,
                                ),
                        ),
                        color: AppColors.blue,
                        onPressed: _loading || !_isValid ? null : verifyAccount,
                      );
                    },
                  ),
                  // SizedBox(height: 20),
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: GestureDetector(
                  //     behavior: HitTestBehavior.opaque,
                  //     child: Text(
                  //       AppLocalization.of(context).trans('resend_code'),
                  //       style: AppTextStyle.smallBlueBold.copyWith(
                  //         decoration: TextDecoration.underline,
                  //       ),
                  //     ),
                  //     onTap: () {
                  //       int type;
                  //       if (validator.isEmail(widget.account)) {
                  //         type = 1;
                  //       } else if (Utils.isPhoneNumber(widget.account)) {
                  //         type = 2;
                  //       } else {
                  //         Fluttertoast.showToast(
                  //           msg: AppLocalization.of(context).trans("accountMustBeEmailOrNumber"),
                  //         );
                  //         return;
                  //       }
                  //
                  //       if (_timer != null && _timer.isActive) {
                  //         Fluttertoast.showToast(
                  //           msg:
                  //           "${AppLocalization.of(context).trans("wait")} $_start ${AppLocalization.of(context).trans("wait_before_try")}",
                  //         );
                  //         return;
                  //       }
                  //       _start = _multi * 20;
                  //       _multi *= 2;
                  //       _timer = new Timer.periodic(Duration(seconds: 1), (Timer timer) {
                  //         if (_start < 1) {
                  //           timer.cancel();
                  //         } else {
                  //           _start = _start - 1;
                  //         }
                  //       });
                  //       bloc.fetchResendCode(context, widget.account, 1, type).then((_) {
                  //         Fluttertoast.showToast(
                  //           msg: AppLocalization.of(context).trans("sent_successfully"),
                  //         );
                  //       }).catchError((e) {
                  //         Fluttertoast.showToast(
                  //           msg: e.toString(),
                  //         );
                  //       });
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
