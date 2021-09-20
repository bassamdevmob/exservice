import 'package:exservice/renovation/bloc/view/account_bloc/account_bloc.dart';
import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:exservice/widget/application/AppVideo.dart';
import 'package:exservice/widget/dialog/ConfirmDialog.dart';
import 'package:exservice/widget/dialog/NoteDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class CompanyVideo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _bloc = context.read<AccountBloc>();
    return BlocListener<AccountBloc, AccountState>(
      listenWhen: (_, current) => current is AccountErrorVideoUploadState,
      listener: (context, state) {
        if (state is AccountErrorVideoUploadState) {
          showDialog(
            context: context,
            builder: (context) => NoteDialog.error(
              state.message,
              onTap: () => Navigator.of(context).pop(),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: BlocBuilder<AccountBloc, AccountState>(
            buildWhen: (_, current) =>
                current is AccountAwaitVideoUploadState ||
                current is AccountVideoState,
            builder: (context, state) {
              if (state is AccountAwaitVideoUploadState) {
                return CupertinoActivityIndicator();
              } else if (_bloc.profile.user.profileVideo == null) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onUpdateVideo(context),
                  child: Text(
                    AppLocalization.of(context).trans('uploadVideo'),
                    style: AppTextStyle.largeBlue,
                  ),
                );
              } else {
                return AppVideo.network(
                  "${_bloc.profile.user.profileVideo}",
                  enablePause: true,
                  fit: false,
                );
              }
            },
          ),
        ),
      ),
    );
  }

  void onUpdateVideo(BuildContext context) async {
    var _bloc = context.read<AccountBloc>();
    final picker = ImagePicker();
    final file = await picker.pickVideo(
      source: ImageSource.gallery,
    );
    if (file == null) return;
    showDialog(
      context: context,
      builder: (dialogContext) => ConfirmDialog(
        description: AppLocalization.of(dialogContext).trans("change_video"),
        onTap: () async {
          Navigator.of(dialogContext).pop();
          _bloc.add(AccountUploadVideoEvent(file.path));
        },
      ),
    );
  }
}
