// import 'dart:async';
// import 'dart:io';
//
// import 'package:exservice/bloc/StatePusher.dart';
// import 'package:exservice/helper/AppConstant.dart';
// import 'package:exservice/models/PostAdModel.dart';
// import 'package:exservice/models/ReviewModel.dart';
// import 'package:exservice/bloc/application_bloc/application_cubit.dart';
// import 'package:exservice/localization/app_localization.dart';
// import 'package:exservice/styles/app_colors.dart';
// import 'package:exservice/styles/app_text_style.dart';
// import 'package:exservice/utils/constant.dart';
// import 'package:exservice/widget/button/app_button.dart';
// import 'package:exservice/resources/api/ApiProviderDelegate.dart';
// import 'package:exservice/ui/post_ad/manage_payment_layout.dart';
// import 'package:exservice/widget/dialog/NoteDialog.dart';
// import 'package:exservice/widget/dialog/ProgressDialog.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
// import 'package:get_it/get_it.dart';
// import 'package:path/path.dart' show basename;
// import 'package:path_provider/path_provider.dart';
//
// Curve _insetAnimCurve = Curves.easeInOut;
// double _dialogElevation = 8.0, _borderRadius = 8.0;
//
// class CompletePublishAd extends StatefulWidget {
//   final ReviewModel details;
//
//   const CompletePublishAd(this.details, {Key key}) : super(key: key);
//
//   @override
//   _CompletePublishAdState createState() => _CompletePublishAdState();
// }
//
// class _CompletePublishAdState extends State<CompletePublishAd> {
//   FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
//   final _pusher = StatePusher<Null>.publish();
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   final _progressModel = ProgressDialogModel();
//
//   Future<PostAdModel> _submit(bool isFree) async {
//     _progressModel.message =
//         '${AppLocalization.of(_scaffoldKey.currentContext).trans("posting")}...';
//
//     try {
//       _progressModel.isShowing = true;
//       showDialog(
//         context: context,
//         builder: (context) {
//           return Dialog(
//             insetAnimationCurve: _insetAnimCurve,
//             insetAnimationDuration: Duration(milliseconds: 100),
//             elevation: _dialogElevation,
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(_borderRadius)),
//             child: StreamBuilder<Null>(
//               stream: _pusher.stream,
//               builder: (context, snapshot) {
//                 return CustomProgressDialog(_progressModel);
//               },
//             ),
//           );
//         },
//       );
//       final result = await GetIt.I
//           .get<ApiProviderDelegate>()
//           .fetchStoreAd(context, widget.details, isFree);
//       int id = result.data.id;
//       final medias = widget.details.media;
//       _progressModel.message = "Uploading...";
//       _progressModel.data = List.generate(medias.length, (index) {
//         return ProgressProperty(
//             "${medias[index].type == AppConstant.imageCode ? "Image" : "Video"}($index)",
//             details: "Waiting...");
//       });
//       _pusher.push();
//       Directory tempDir = await getTemporaryDirectory();
//       String tempPath = tempDir.path;
//       for (int i = 0; i < medias.length; i++) {
//         ReviewMedia media = widget.details.media[i];
//         if (media.type == AppConstant.videoCode) {
//           _progressModel.data[i].details =
//               '${AppLocalization.of(_scaffoldKey.currentContext).trans("compressingVideo")} ($i)...';
//           _pusher.push();
//           try {
//             String pickedPath = media.file;
//             String target = '$tempPath/${basename(pickedPath)}.mp4';
//             final arguments = '-i $pickedPath ' +
//                 '-preset faster ' +
//                 '-g 48 -sc_threshold 0  ' +
//                 '-vf scale=-1:480 ' +
//                 '-c:v libx264 ' +
//                 '-crf 30 ' +
//                 '-c:a copy ' +
//                 '-filter:v "crop=ih*($ASPECT_RATIO):ih" ' +
//                 target;
//             var result = await _flutterFFmpeg.execute(arguments);
//             if (result == 0) {
//               print("compress success");
//               media.compressed = target;
//             }
//           } catch (e) {
//             print(e);
//           } finally {
//             _progressModel.data[i].showProgress = true;
//             _progressModel.data[i].details =
//                 '${AppLocalization.of(_scaffoldKey.currentContext).trans("uploadingVideo")} ($i)...';
//             _pusher.push();
//           }
//         } else {
//           _progressModel.data[i].showProgress = true;
//           _progressModel.data[i].details =
//               '${AppLocalization.of(_scaffoldKey.currentContext).trans("uploadingImage")} ($i)...';
//           _pusher.push();
//         }
//         final res = await GetIt.I.get<ApiProviderDelegate>().fetchUploadAdMedia(
//             id, media, (i == medias.length - 1) ? 1 : 0, (count, total) {
//           var elem = _progressModel.data[i];
//           elem.progress = (count / kFromByteToMega);
//           elem.maxProgress = (total / kFromByteToMega);
//           _pusher.push();
//         });
//         if (res.code < 0) {
//           throw res.message;
//         }
//         if (media.compressed != null) {
//           File(media.compressed).delete();
//           media.compressed = null;
//         }
//       }
//
//       if (_progressModel.isShowing) {
//         Navigator.of(_scaffoldKey.currentContext).pop();
//         _progressModel.isShowing = false;
//       }
//
//       return result;
//     } catch (e) {
//       if (_progressModel.isShowing) {
//         Navigator.of(_scaffoldKey.currentContext).pop();
//         _progressModel.isShowing = false;
//       }
//       rethrow;
//     }
//   }
//
//   Widget getEndWithPayDialog(PostAdModel res) {
//     return AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       title: Text(AppLocalization.of(context).trans('note')),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           Text(
//             AppLocalization.of(context).trans("postPublished"),
//             style: AppTextStyle.mediumBlack,
//           ),
//           SizedBox(height: 10),
//           Text(
//             res.message,
//             style: AppTextStyle.mediumBlack,
//           ),
//           SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               AppButton(
//                 child: Text(
//                   AppLocalization.of(context).trans('later'),
//                   style: AppTextStyle.largeBlack,
//                 ),
//                 onTap: () {
//                   BlocProvider.of<ApplicationCubit>(context).refresh();
//                 },
//               ),
//               AppButton(
//                 child: Text(
//                   AppLocalization.of(context).trans('pay'),
//                   style: AppTextStyle.largeBlack,
//                 ),
//                 onTap: () {
//                   Navigator.of(context).push(CupertinoPageRoute(
//                     builder: (context) => ManagePayment(res.data.id),
//                   ));
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget getEndDialog() {
//     return AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       title: Text(AppLocalization.of(context).trans('note')),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           Text(
//             AppLocalization.of(context).trans("postPublished"),
//             style: AppTextStyle.mediumBlack,
//           ),
//           SizedBox(height: 10),
//           RaisedButton(
//             child: Padding(
//               padding: const EdgeInsets.all(10),
//               child: Text(
//                 AppLocalization.of(context).trans('ok'),
//                 style: AppTextStyle.mediumWhite,
//               ),
//             ),
//             color: AppColors.blue,
//             onPressed: () {
//               BlocProvider.of<ApplicationCubit>(context).refresh();
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future showError(e) {
//     return showDialog(
//       context: _scaffoldKey.currentContext,
//       builder: (context) {
//         return NoteDialog.error(
//           e.toString(),
//           onTap: () {
//             Navigator.of(context).pop();
//           },
//         );
//       },
//     );
//   }
//
//   void submitFree() {
//     _submit(true).then((res) {
//       if (res.code == -5) {
//         showDialog(
//           context: _scaffoldKey.currentContext,
//           builder: (context) => getEndWithPayDialog(res),
//         );
//       } else {
//         showDialog(
//           context: _scaffoldKey.currentContext,
//           builder: (context) => getEndDialog(),
//         );
//       }
//     }).catchError((e) {
//       showError(e);
//     });
//   }
//
//   void submitPaid() {
//     _submit(false).then((res) {
//       Navigator.of(context).push(CupertinoPageRoute(
//         builder: (context) => ManagePayment(res.data.id),
//       ));
//     }).catchError((e) {
//       showError(e);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: BottomAppBar(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: AppButton(
//                   child: Padding(
//                     padding: const EdgeInsets.all(10),
//                     child: Text(
//                       AppLocalization.of(context).trans('free'),
//                       style: AppTextStyle.largeBlack,
//                     ),
//                   ),
//                   onTap: submitFree,
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: AppButton(
//                   child: Padding(
//                     padding: const EdgeInsets.all(10),
//                     child: Text(
//                       AppLocalization.of(context).trans('paid'),
//                       style: AppTextStyle.largeBlack,
//                     ),
//                   ),
//                   onTap: submitPaid,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       key: _scaffoldKey,
//       appBar: AppBar(
//         backgroundColor: AppColors.white,
//         iconTheme: IconThemeData(color: AppColors.blue),
//         centerTitle: true,
//         title: Text(
//           AppLocalization.of(context).trans('app_name'),
//           style: AppTextStyle.largeBlack,
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             SizedBox(height: 20),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Container(
//                   margin: const EdgeInsets.all(8.0),
//                   width: 15,
//                   height: 15,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     gradient: LinearGradient(
//                       colors: [AppColors.blue, AppColors.deepPurple],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Text(
//                     AppLocalization.of(context).trans('freeDesc'),
//                     style: AppTextStyle.largeBlack,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Container(
//                   margin: const EdgeInsets.all(8.0),
//                   width: 15,
//                   height: 15,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     gradient: LinearGradient(
//                       colors: [AppColors.blue, AppColors.deepPurple],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Text(
//                     AppLocalization.of(context).trans('paidDesc'),
//                     style: AppTextStyle.largeBlack,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
