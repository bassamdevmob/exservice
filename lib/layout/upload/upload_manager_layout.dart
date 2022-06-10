import 'package:flutter/material.dart';

class UploadManagerLayout extends StatefulWidget {
  const UploadManagerLayout({Key key}) : super(key: key);

  @override
  State<UploadManagerLayout> createState() => _UploadManagerLayoutState();
}

class _UploadManagerLayoutState extends State<UploadManagerLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

//  Future<PostAdModel> _submit(bool isFree) async {
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