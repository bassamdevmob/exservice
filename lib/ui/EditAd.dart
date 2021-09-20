import 'package:exservice/bloc/StatePusher.dart';
import 'package:exservice/models/common/AdModel.dart';
import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/styles/app_colors.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:exservice/renovation/utils/constant.dart';
import 'package:exservice/renovation/widget/button/app_button.dart';
import 'package:exservice/resources/api/ApiProviderDelegate.dart';
import 'package:exservice/widget/application/AppTextField.dart';
import 'package:exservice/widget/dialog/ConfirmDialog.dart';
import 'package:exservice/widget/dialog/NoteDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

class EditAd extends StatefulWidget {
  final AdModel ad;

  const EditAd(this.ad, {Key key}) : super(key: key);

  @override
  _EditAdState createState() => _EditAdState();
}

class _EditAdState extends State<EditAd> {
  final _loadingPusher = StatePusher<Null>.publish();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    try {
      _titleController.text = widget.ad.title;
      _descriptionController.text = widget.ad.description;
    } finally {}
    super.initState();
  }

  @override
  void dispose() {
    _loadingPusher.dispose();
    super.dispose();
  }

  _fetchEdit() {
    showDialog(
      context: context,
      builder: (dialogContext) => ConfirmDialog(
        description: AppLocalization.of(context).trans("confirmEdit"),
        onTap: () async {
          Navigator.of(dialogContext).pop();
          _loading = true;
          _loadingPusher.push();
          try {
            await GetIt.I.get<ApiProviderDelegate>().fetchEditAd(
                  context,
                  widget.ad.id,
                  _titleController.text,
                  _descriptionController.text,
                );
            widget.ad.title = _titleController.text;
            widget.ad.description = _descriptionController.text;
            // widget.ad.attributes.first.price = _priceValue.toString();
            Navigator.of(context).pop();
          } catch (e) {
            showDialog(
              context: context,
              builder: (context) => NoteDialog.error(
                e.toString(),
                onTap: () => Navigator.of(context).pop(),
              ),
            );
            _loading = false;
            _loadingPusher.push();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final viewInsets = MediaQuery.of(context).viewInsets;
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: StreamBuilder<Null>(
          stream: _loadingPusher.stream,
          builder: (context, snapshot) {
            bool valid = _titleController.text.isNotEmpty &&
                _descriptionController.text.isNotEmpty;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppButton(
                child: _loading
                    ? CupertinoActivityIndicator()
                    : Text(
                        AppLocalization.of(context).trans('edit'),
                        style: AppTextStyle.largeBlack,
                      ),
                onTap: _loading || !valid ? null : _fetchEdit,
              ),
            );
            // return Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: RaisedButton(
            //     child: Padding(
            //       padding: const EdgeInsets.all(12.0),
            //       child: _loading
            //           ? SizedBox(
            //               height: 20,
            //               width: 20,
            //               child: CircularProgressIndicator(),
            //             )
            //           : Text(
            //               AppLocalization.of(context).trans('edit'),
            //               style: AppTextStyle.mediumWhite,
            //             ),
            //     ),
            //     color: AppColors.blue,
            //     onPressed: _loading || !valid ? null : _fetchEdit,
            //   ),
            // );
          },
        ),
      ),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        iconTheme: IconThemeData(color: AppColors.blue),
        centerTitle: true,
        title: Text(
          AppLocalization.of(context).trans('app_name'),
          style: AppTextStyle.largeBlack,
        ),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: height -
                viewInsets.bottom -
                ASPECT_RATIO -
                kBottomNavigationBarHeight -
                8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                child: AppTextField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(60),
                  ],
                  maxLines: 2,
                  borderType: AppInputFieldBorder.UnderlineInputBorder,
                  controller: _titleController,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  label: AppLocalization.of(context).trans('title'),
                  bioStyle: AppTextStyle.mediumGray,
                  style: AppTextStyle.mediumBlack,
                  focusColor: AppColors.gray,
                  borderColor: AppColors.gray,
                  backgroundColor: AppColors.grayAccentLight,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                child: AppTextField(
                  borderType: AppInputFieldBorder.UnderlineInputBorder,
                  controller: _descriptionController,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  label: AppLocalization.of(context).trans('desc'),
                  bioStyle: AppTextStyle.mediumGray,
                  style: AppTextStyle.mediumBlack,
                  focusColor: AppColors.gray,
                  borderColor: AppColors.gray,
                  backgroundColor: AppColors.grayAccentLight,
//                      errorText: snapshot.data,
                ),
              ),
              // SizedBox(height: 10),
              // StreamBuilder<Null>(
              //     stream: _sliderPusher.stream,
              //     builder: (context, snapshot) {
              //     return Padding(
              //       padding: const EdgeInsets.symmetric(horizontal: 30),
              //       child: Text(
              //         "${AppLocalization.of(context).trans('price')} : $_priceValue",
              //         style: AppTextStyle.mediumBlue,
              //       ),
              //     );
              //   }
              // ),
              // Padding(
              //   padding:
              //       const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              //   child: StreamBuilder<Null>(
              //     stream: _sliderPusher.stream,
              //     builder: (context, snapshot) {
              //       return Slider(
              //         divisions: 100,
              //         label: '$_priceValue',
              //         value: _priceIndex,
              //         onChanged: (val) {
              //           _priceIndex = val;
              //           _priceValue = (_priceIndex * kMultiplyNumber).round();
              //           _sliderPusher.push();
              //         },
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
