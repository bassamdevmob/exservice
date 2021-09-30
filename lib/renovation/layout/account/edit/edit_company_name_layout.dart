import 'package:exservice/renovation/bloc/account/edit_account_bloc/edit_account_cubit.dart';
import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/styles/app_colors.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:exservice/renovation/widget/bottom_sheets/error_bottom_sheet.dart';
import 'package:exservice/widget/dialog/ConfirmDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

// class EditCompanyNameLayout extends StatefulWidget {
//   @override
//   _EditCompanyNameLayoutState createState() => _EditCompanyNameLayoutState();
// }
//
// class _EditCompanyNameLayoutState extends State<EditCompanyNameLayout> {
//   User user;
//   final _controller = TextEditingController();
//
//   @override
//   void initState() {
//     user = BlocProvider.of<AccountBloc>(context).profile.user;
//     _controller.text = user.username;
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   _fetchEdit() {
//     if (user.username == _controller.text) {
//       Fluttertoast.showToast(
//           msg: AppLocalization.of(context).trans("same_company_name"));
//       return;
//     }
//     if (_controller.text.isEmpty) {
//       Fluttertoast.showToast(
//           msg: AppLocalization.of(context).trans("invalid_name"));
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
//             await GetIt.I
//                 .get<ApiProviderDelegate>()
//                 .fetchEditProfile(context, companyName: _controller.text);
//             user.username = _controller.text;
//             Fluttertoast.showToast(
//               msg: AppLocalization.of(context).trans("edited"),
//             );
//             Navigator.of(context).pop();
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
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.grayAccentLight,
//         title: Text(
//           AppLocalization.of(context).trans('changeCompanyName'),
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
//                 AppLocalization.of(context).trans("companyName"),
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
//                 ? CupertinoActivityIndicator()
//                 : Icon(Icons.check, color: AppColors.green),
//           ),
//         );
//       },
//     );
//   }
// }

class EditAccountFieldLayout extends StatefulWidget {
  @override
  _EditAccountFieldLayoutState createState() => _EditAccountFieldLayoutState();
}

class _EditAccountFieldLayoutState extends State<EditAccountFieldLayout> {
  EditAccountCubit _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<EditAccountCubit>(context);
    super.initState();
  }

  _edit() {
    showDialog(
      context: context,
      builder: (ctx) => ConfirmDialog(
        description: AppLocalization.of(context).trans("edit_profile_warning"),
        onTap: () {
          Navigator.of(ctx).pop();
          _bloc.update().whenComplete(() {
            Navigator.of(context).pop();
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditAccountCubit, EditAccountState>(
      listenWhen: (_, current) =>
          current is EditAccountCommittedState ||
          current is EditAccountErrorState,
      listener: (context, state) {
        if (state is EditAccountCommittedState) {
          Fluttertoast.showToast(
            msg: AppLocalization.of(context).trans("edited"),
          );
          Navigator.of(context).pop();
        } else if (state is EditAccountErrorState) {
          showErrorBottomSheet(
            context,
            AppLocalization.of(context).trans("error"),
            state.message,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.grayAccentLight,
          title: Text(
            AppLocalization.of(context).trans('changeCompanyName'),
            style: AppTextStyle.largeBlack,
          ),
          actions: <Widget>[
            getActionButton(),
            SizedBox(width: 5),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalization.of(context).trans("companyName"),
                  style: AppTextStyle.mediumBlack,
                ),
              ),
              SizedBox(height: 10),
              BlocBuilder<EditAccountCubit, EditAccountState>(
                buildWhen: (_, current) => current is EditAccountInitial,
                builder: (context, state) {
                  return TextField(
                    // controller: _bloc.factory.controller,
                    maxLines: 1, //todo fix every thing
                    decoration: InputDecoration(
                      // errorText: _bloc.errorMessage,
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.gray),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.blue),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  Widget getActionButton() {
    return BlocBuilder<EditAccountCubit, EditAccountState>(
      buildWhen: (_, current) =>
          current is EditAccountAwaitState ||
          current is EditAccountCommittedState ||
          current is EditAccountErrorState,
      builder: (context, state) {
        return IconButton(
          onPressed: state is EditAccountAwaitState ? null : _edit,
          icon: Padding(
            padding: const EdgeInsets.all(3.0),
            child: state is EditAccountAwaitState
                ? CupertinoActivityIndicator()
                : Icon(Icons.check, color: AppColors.green),
          ),
        );
      },
    );
  }
}
