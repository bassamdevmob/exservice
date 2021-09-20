import 'package:exservice/bloc/StatePusher.dart';
import 'package:exservice/helper/AppConstant.dart';
import 'package:exservice/renovation/controller/data_store.dart';
import 'package:exservice/renovation/layout/auth/Intro_layout.dart';
import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/styles/app_colors.dart';
import 'package:exservice/resources/api/ApiProviderDelegate.dart';
import 'package:exservice/widget/dialog/ConfirmDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';

class BookMark extends StatefulWidget {
  final int id;
  final bool checked;

  const BookMark(this.id, this.checked, {Key key}) : super(key: key);

  @override
  _BookMarkState createState() => _BookMarkState();
}

class _BookMarkState extends State<BookMark> {
  final _pusher = StatePusher<bool>.behavior();
  bool _checked;

  @override
  void initState() {
    _checked = widget.checked;
    super.initState();
  }

  @override
  void dispose() {
    _pusher.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _pusher.stream,
      initialData: _checked,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return InkWell(
            onTap: () async {
              if (DataStore.instance.user == null) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return ConfirmDialog(
                      description: AppLocalization.of(context)
                          .trans('getAccountToSaveAd'),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => IntroLayout()),
                        );
                      },
                    );
                  },
                );
                return;
              }
              if (_checked) {
                bool result = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return ConfirmDialog(
                      description:
                          AppLocalization.of(context).trans('sureUnCheck'),
                      onTap: () {
                        Navigator.of(context).pop(true);
                      },
                    );
                  },
                );
                if (result != true) return;
              }

              _pusher.push();
              GetIt.I
                  .get<ApiProviderDelegate>()
                  .fetchSaveAd(context, widget.id, _checked)
                  .then((_) {
                _checked = !_checked;
                _pusher.push(_checked);
              }).catchError((e) {
                _pusher.push(_checked);
                Fluttertoast.showToast(msg: e);
              });
            },
            child: SvgPicture.asset(
              AppConstant.bookmarkSvg,
              semanticsLabel: 'bookmark',
              color: snapshot.data ? AppColors.black : null,
            ),
          );
        }

        return SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
