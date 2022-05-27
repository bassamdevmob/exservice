import 'package:exservice/bloc/profile_bloc/profile_bloc.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:exservice/widget/dialogs/confirm_dialog.dart';
import 'package:exservice/widget/dialogs/error_dialog.dart';
import 'package:exservice/widget/application/app_video.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class CompanyVideo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _bloc = context.read<ProfileBloc>();
    return BlocListener<ProfileBloc, ProfileState>(
      listenWhen: (_, current) => current is ProfileErrorVideoUploadState,
      listener: (context, state) {
        if (state is ProfileErrorVideoUploadState) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(state.message),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: BlocBuilder<ProfileBloc, ProfileState>(
            buildWhen: (_, current) =>
                current is ProfileAwaitVideoUploadState ||
                current is ProfileVideoState,
            builder: (context, state) {
              if (state is ProfileAwaitVideoUploadState) {
                return CupertinoActivityIndicator();
              } else if (_bloc.model.profileVideo == null) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onUpdateVideo(context),
                  child: Text(
                    AppLocalization.of(context).translate('uploadVideo'),
                    style: AppTextStyle.largeBlue,
                  ),
                );
              } else {
                return AppVideo.network(
                  "${_bloc.model.profileVideo}",
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
    var _bloc = context.read<ProfileBloc>();
    final picker = ImagePicker();
    final file = await picker.pickVideo(
      source: ImageSource.gallery,
    );
    if (file == null) return;
    showDialog(
      context: context,
      builder: (dialogContext) => ConfirmDialog(
        text: AppLocalization.of(dialogContext).translate("change_video"),
        onTap: () async {
          Navigator.of(dialogContext).pop();
          _bloc.add(ProfileUploadVideoEvent(file.path));
        },
      ),
    );
  }
}
