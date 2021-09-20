import 'dart:io';

import 'package:exservice/bloc/StatePusher.dart';
import 'package:exservice/helper/AppConstant.dart';
import 'package:exservice/models/ReviewModel.dart';
import 'package:exservice/renovation/controller/data_store.dart';
import 'package:exservice/renovation/layout/auth/Intro_layout.dart';
import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/styles/app_colors.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:exservice/ui/post_ad/ReviewAdDetailsPage.dart';
import 'package:exservice/widget/application/AppTextField.dart';
import 'package:exservice/widget/application/AppVideo.dart';
import 'package:exservice/widget/buttons/CustomAppButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class PostAdMediaPage extends StatefulWidget {
  final ReviewModel details;

  const PostAdMediaPage(this.details, {Key key}) : super(key: key);

  // static void refresh(BuildContext context){
  //   context.findAncestorStateOfType<_PostAdMediaPageState>().refresh();
  // }

  @override
  _PostAdMediaPageState createState() => _PostAdMediaPageState();
}

class _PostAdMediaPageState extends State<PostAdMediaPage>
    with WidgetsBindingObserver {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _mediaPusher = StatePusher<void>.behavior();
  final picker = ImagePicker();

  //
  // void refresh(){
  //   setState(() {});
  // }

  @override
  void initState() {
    if (widget.details.media == null) widget.details.media = [];
    _descriptionController.text = widget.details.description;
    _titleController.text = widget.details.title;
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      FocusScope.of(context).unfocus();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _mediaPusher.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        iconTheme: IconThemeData(color: AppColors.blue),
        centerTitle: true,
        title: Text(
          AppLocalization.of(context).trans('app_name'),
          style: AppTextStyle.largeBlack,
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8),
            child: AppTextField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(60),
              ],
              maxLines: 2,
              hint: AppLocalization.of(context).trans('title'),
              controller: _titleController,
              bioStyle: AppTextStyle.largeGray,
              padding: EdgeInsets.zero,
              prefix: Container(
                constraints: BoxConstraints(maxWidth: 30),
                child: Center(
                  child: Image.asset(
                    'assets/images/ic_description.png',
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
              style: AppTextStyle.largeBlack,
              focusColor: AppColors.black,
              borderColor: AppColors.black,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: AppTextField(
              hint: AppLocalization.of(context).trans('desc'),
              controller: _descriptionController,
              bioStyle: AppTextStyle.largeGray,
              padding: EdgeInsets.zero,
              prefix: Container(
                constraints: BoxConstraints(maxWidth: 30),
                child: Center(
                  child: Image.asset(
                    'assets/images/ic_title.png',
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
              style: AppTextStyle.largeBlack,
              focusColor: AppColors.black,
              borderColor: AppColors.black,
            ),
          ),
          Expanded(
            child: StreamBuilder<void>(
              stream: _mediaPusher.stream,
              builder: (context, snapshot) {
                return getMediaWidgets();
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: !DataStore.instance.hasUser
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: AppColors.blue),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
                    child: Text(
                      AppLocalization.of(context).trans('getAccount'),
                      style: AppTextStyle.mediumWhite,
                    ),
                  ),
                  color: AppColors.blue,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => IntroLayout(),
                      ),
                    );
                    // ModalRoute.of(context).
                  },
                ),
              )
            : Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.deepGray,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: CustomAppButton(
                        child: Icon(
                          Icons.camera_alt,
                          size: 30,
                          color: AppColors.white,
                        ),
                        color: AppColors.blue,
                        borderRadius: BorderRadius.circular(100),
                        onTap: () async {
                          final imagesCount = widget.details.media
                              .where((element) =>
                                  element.type == AppConstant.imageCode)
                              .length;
                          if ((DataStore.instance.user.type.isCompany &&
                                  imagesCount >= 10) ||
                              (!DataStore.instance.user.type.isCompany &&
                                  imagesCount >= 6)) {
                            Fluttertoast.showToast(
                              msg: AppLocalization.of(context)
                                  .trans('allowedAdNum'),
                            );
                            return;
                          }
                          final file = await picker.getImage(
                            source: ImageSource.gallery,
                          );
                          if (file == null) return;
                          widget.details.media.add(
                              ReviewMedia(file.path, AppConstant.imageCode));
                          _mediaPusher.push();
                        },
                      ),
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: AppColors.blue),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
                        child: Text(
                          AppLocalization.of(context).trans('review'),
                          style: AppTextStyle.mediumWhite,
                        ),
                      ),
                      color: AppColors.blue,
                      onPressed: () {
                        // if (DataStore.instance.user == null) {
                        //   Navigator.of(context).push(
                        //     MaterialPageRoute(
                        //       builder: (context) => Intro(),
                        //     ),
                        //   );
                        //   return;
                        // }

                        if (_titleController.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: AppLocalization.of(context)
                                  .trans('reqTitle'));
                          return;
                        }
                        if (_descriptionController.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg:
                                  AppLocalization.of(context).trans('reqDesc'));
                          return;
                        }
//                  if (widget.details.media.isEmpty) {
//                    Fluttertoast.showToast(
//                        msg: AppLocalization.of(context).trans('reqMedia'));
//                    return;
//                  }

                        widget.details.description =
                            _descriptionController.text;
                        widget.details.title = _titleController.text;

                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) =>
                                ReviewAdDetailsPage(widget.details),
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: CustomAppButton(
                        child: Icon(
                          Icons.videocam,
                          size: 30,
                          color: AppColors.white,
                        ),
                        color: AppColors.blue,
                        borderRadius: BorderRadius.circular(100),
                        onTap: () async {
                          final imagesCount = widget.details.media
                              .where((element) =>
                                  element.type == AppConstant.videoCode)
                              .length;
                          if ((DataStore.instance.user.type.isCompany &&
                                  imagesCount >= 2) ||
                              (!DataStore.instance.user.type.isCompany &&
                                  imagesCount >= 1)) {
                            Fluttertoast.showToast(
                              msg: AppLocalization.of(context)
                                  .trans('allowedAdNum'),
                            );
                            return;
                          }
                          final file = await picker.getVideo(
                            source: ImageSource.gallery,
                            maxDuration: DataStore.instance.user.type.isCompany
                                ? Duration(minutes: 1)
                                : Duration(seconds: 30),
                          );
                          if (file == null) return;
                          widget.details.media.add(
                              ReviewMedia(file.path, AppConstant.videoCode));
                          _mediaPusher.push();
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget getMediaWidgets() {
    if (widget.details.media == null || widget.details.media.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            AppLocalization.of(context).trans('noMedia'),
            style: AppTextStyle.mediumBlue,
          ),
        ),
      );
    } else {
      return Swiper(
        curve: Curves.linear,
        viewportFraction: 0.75,
        scale: 0.8,
        itemCount: widget.details.media.length,
        loop: false,
        pagination: SwiperPagination(),
        itemBuilder: (BuildContext context, index) {
          if (widget.details.media[index].type == 1) {
            return getMediaCard(
              index,
              Image.file(
                File(widget.details.media[index].file),
                fit: BoxFit.cover,
              ),
            );
          } else {
            return getMediaCard(
              index,
              Center(
                child: AppVideo.file(
                  File(widget.details.media[index].file),
                ),
              ),
            );
          }
        },
      );
    }
  }

  Widget getMediaCard(int index, Widget child) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        child,
        Positioned(
          top: 10,
          right: 10,
          child: CustomAppButton(
            borderRadius: BorderRadius.circular(100),
            color: AppColors.blue,
            child: Icon(
              Icons.delete,
              color: AppColors.white,
            ),
            onTap: () {
              widget.details.media.removeAt(index);
              _mediaPusher.push();
            },
          ),
        )
      ],
    );
  }
}
