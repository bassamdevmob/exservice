// import 'package:exservice/bloc/StatePusher.dart';
// import 'package:exservice/helper/AppConstant.dart';
// import 'package:exservice/renovation/localization/app_localization.dart';
// import 'package:exservice/renovation/styles/app_colors.dart';
// import 'package:exservice/renovation/styles/app_text_style.dart';
// import 'package:exservice/resources/AccountManager.dart';
// import 'package:exservice/resources/api/ApiProviderDelegate.dart';
// import 'package:exservice/ui/personal_account/edit_property/CompleteAccountUpdate.dart';
// import 'package:exservice/widget/application/AppTextField.dart';
// import 'package:exservice/widget/dialog/ConfirmDialog.dart';
// import 'package:exservice/widget/dialog/NoteDialog.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get_it/get_it.dart';
// import 'package:string_validator/string_validator.dart' as validator;
//
// class EditEmail extends StatefulWidget {
//   @override
//   _EditEmailState createState() => _EditEmailState();
// }
//
// class _EditEmailState extends State<EditEmail> with WidgetsBindingObserver {
//   final _controller = TextEditingController();
//   final _loadPusher = StatePusher<bool>.behavior();
//   final _validatorPusher = StatePusher<String>.publish();
//
//   _fetchEdit() {
//     if (GetIt.I.get<AccountManager>().profile.user.email == _controller.text) {
//       Fluttertoast.showToast(
//           msg: AppLocalization.of(context).trans("cannotSubmitTheSameEmail"));
//       return;
//     }
//     if (!validator.isEmail(_controller.text)) {
//       Fluttertoast.showToast(
//         msg: AppLocalization.of(context).trans("invalid_email"),
//       );
//       return;
//     }
//     showDialog(
//       context: context,
//       builder: (dialogContext) => ConfirmDialog(
//         description: AppLocalization.of(context).trans("edit_profile_warning"),
//         onTap: () async {
//           Navigator.of(dialogContext).pop();
//           _loadPusher.push(true);
//           try {
//             await GetIt.I.get<ApiProviderDelegate>().fetchUpdateEmailPhone(
//                 context, _controller.text, AppConstant.emailCode);
//             Navigator.of(context).push(
//               CupertinoPageRoute(
//                 builder: (context) => CompleteAccountUpdate(
//                     _controller.text, AppConstant.emailCode),
//               ),
//             );
//           } catch (e) {
//             showDialog(
//               context: context,
//               builder: (context) => NoteDialog.error(
//                 e.toString(),
//                 onTap: () => Navigator.of(context).pop(),
//               ),
//             );
//           } finally {
//             _loadPusher.push(false);
//           }
//         },
//       ),
//     );
//   }
//
//   _listener() {
//     if (_controller.text.isEmpty || !validator.isEmail(_controller.text)) {
//       print("invalid");
//       _validatorPusher.push(AppLocalization.of(context).trans("invalid_email"));
//     } else {
//       _validatorPusher.push();
//     }
//   }
//
//   @override
//   void initState() {
//     _controller.text = GetIt.I.get<AccountManager>().profile.user.email;
//     _controller.addListener(_listener);
//     WidgetsBinding.instance.addObserver(this);
//     super.initState();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     super.didChangeAppLifecycleState(state);
//     if (state == AppLifecycleState.paused) {
//       FocusScope.of(context).unfocus();
//     }
//   }
//
//   @override
//   void dispose() {
//     _controller.removeListener(_listener);
//     _controller.dispose();
//     _loadPusher.dispose();
//     _validatorPusher.dispose();
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.grayAccentLight,
//         title: Text(
//           AppLocalization.of(context).trans('changeEmail'),
//           style: AppTextStyle.largeBlack,
//         ),
//         actions: <Widget>[
//           getActionButton(),
//           SizedBox(width: 5),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: <Widget>[
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 AppLocalization.of(context).trans("email2"),
//                 style: AppTextStyle.mediumBlack,
//               ),
//             ),
//             SizedBox(height: 10),
//             StreamBuilder<String>(
//               stream: _validatorPusher.stream,
//               builder: (context, snapshot) {
//                 return AppTextField(
//                   errorText: snapshot.data,
//                   borderType: AppInputFieldBorder.UnderlineInputBorder,
//                   controller: _controller,
//                   padding: EdgeInsets.symmetric(horizontal: 5),
//                   bioStyle: AppTextStyle.mediumGray,
//                   style: AppTextStyle.mediumBlack,
//                   focusColor: AppColors.gray,
//                   borderColor: AppColors.gray,
//                   maxLines: 1,
//                   inputFormatters: [
//                     LengthLimitingTextInputFormatter(100),
//                   ],
//                   backgroundColor: AppColors.grayAccentLight,
//                 );
//               },
//             ),
//             SizedBox(height: 15),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget getActionButton() {
//     return StreamBuilder<bool>(
//       stream: _loadPusher.stream,
//       builder: (context, snapshot) {
//         return InkWell(
//           onTap: () async {
//             _fetchEdit();
//           },
//           borderRadius: BorderRadius.circular(100),
//           child: Padding(
//             padding: const EdgeInsets.all(3.0),
//             child: snapshot.data == true
//                 ? SizedBox(
//                     child: CupertinoActivityIndicator(),
//                     height: 20,
//                   )
//                 : Icon(
//                     Icons.check,
//                     color: AppColors.green,
//                   ),
//           ),
//         );
//       },
//     );
//   }
// }
