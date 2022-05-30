import 'package:exservice/bloc/account/business_info_bloc/business_info_bloc.dart';
import 'package:exservice/bloc/account/change_password_bloc/change_password_bloc.dart';
import 'package:exservice/bloc/profile_bloc/profile_bloc.dart';
import 'package:exservice/layout/account/edit/change_password_layout.dart';
import 'package:exservice/layout/account/contact_info_layout.dart';
import 'package:exservice/layout/account/edit/edit_business_info_layout.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:exservice/widget/application/dotted_container.dart';
import 'package:exservice/widget/application/global_widgets.dart';
import 'package:exservice/widget/bottom_sheets/error_bottom_sheet.dart';
import 'package:exservice/widget/button/action_button.dart';
import 'package:exservice/widget/dialogs/confirm_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:octo_image/octo_image.dart';

class EditAccountLayout extends StatefulWidget {
  @override
  _EditAccountLayoutState createState() => _EditAccountLayoutState();
}

class _EditAccountLayoutState extends State<EditAccountLayout> {
  final picker = ImagePicker();
  ProfileBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<ProfileBloc>(context);
    super.initState();
  }

  void changeProfilePic() async {
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      showDialog(
        context: context,
        builder: (dialogContext) => ConfirmDialog(
          mediaPath: file.path,
          text: AppLocalization.of(dialogContext).translate("changeImage"),
          onTap: () {
            Navigator.of(dialogContext).pop();
            _bloc.add(ProfileChangeProfileImageEvent(file.path));
          },
        ),
      );
    }
  }

  Widget getInfoTile(String key, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(key, style: AppTextStyle.mediumBlack),
          val == null
              ? Text(
                  AppLocalization.of(context).translate("notAssigned"),
                  style: AppTextStyle.largeGray,
                )
              : Text(val, style: AppTextStyle.largeBlackBold),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var user = context.read<ProfileBloc>().model;
    return BlocListener<ProfileBloc, ProfileState>(
      listenWhen: (_, current) => current is ProfileErrorImageUploadState,
      listener: (context, state) {
        if (state is ProfileErrorImageUploadState) {
          showErrorBottomSheet(
            context,
            AppLocalization.of(context).translate("error"),
            state.message,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.white,
          iconTheme: IconThemeData(color: AppColors.blue),
          centerTitle: true,
          title: Text(
            AppLocalization.of(context).translate("app_name"),
            style: AppTextStyle.largeLobsterBlack,
          ),
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          buildWhen: (_, current) => current is ProfileInitial,
          builder: (context, state) {
            return ListView(
              padding: EdgeInsets.symmetric(vertical: 20),
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OutlineContainer(
                            dimension: 80,
                            radius: 40,
                            strokeWidth: 1,
                            gradient: LinearGradient(
                              colors: [AppColors.blue, AppColors.deepPurple],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            child: ClipOval(
                              child: OctoImage(
                                key: ValueKey(user.profilePicture),
                                fit: BoxFit.cover,
                                image: NetworkImage(user.profilePicture),
                                progressIndicatorBuilder: (context, progress) {
                                  return simpleShimmer;
                                },
                                errorBuilder: (context, e, _) => Container(
                                  alignment: Alignment.center,
                                  color: AppColors.grayAccent,
                                  child: Text(
                                    user.username,
                                    style: AppTextStyle.xxLargeBlack,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned.directional(
                          start: 0,
                          bottom: 0,
                          textDirection: Directionality.of(context),
                          child: BlocBuilder<ProfileBloc, ProfileState>(
                            buildWhen: (_, current) =>
                                current is ProfileImageState ||
                                current is ProfileAwaitImageUploadState ||
                                current is ProfileErrorImageUploadState,
                            builder: (context, state) {
                              return MaterialButton(
                                color: state is ProfileAwaitImageUploadState
                                    ? AppColors.gray
                                    : AppColors.blue,
                                minWidth: 0,
                                padding: EdgeInsets.all(5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: AppColors.white,
                                ),
                                onPressed: state is ProfileAwaitImageUploadState
                                    ? null
                                    : changeProfilePic,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Text(
                      user.username,
                      style: AppTextStyle.largeBlack,
                    ),
                    Divider(),
                  ],
                ),
                ActionButton(
                  AppLocalization.of(context).translate("contact_info"),
                  AppLocalization.of(context).translate("contact_info_desc"),
                  () {
                    Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => ContactInfoLayout(),
                    ));
                    //                InkWell(
                    //                   onTap: () {
                    //                     //todo update
                    //                     Navigator.of(context).push(CupertinoPageRoute(
                    //                       builder: (context) => EditEmail(),
                    //                     ));
                    //                   },
                    //                   child: getInfoTile(
                    //                     AppLocalization.of(context).trans('email2'),
                    //                     user.email,
                    //                   ),
                    //                 ),
                    //                 InkWell(
                    //                   onTap: () {
                    //                     //todo update
                    //                     Navigator.of(context).push(CupertinoPageRoute(
                    //                       builder: (context) => EditPhoneNumber(),
                    //                     ));
                    //                   },
                    //                   child: getInfoTile(
                    //                     AppLocalization.of(context).trans('phoneNumber'),
                    //                     user.phoneNumber,
                    //                   ),
                    //                 ),
                  },
                ),
                ActionButton(
                  AppLocalization.of(context).translate("business_info"),
                  AppLocalization.of(context).translate("business_info_desc"),
                  () {
                    Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => BusinessInfoBloc(context),
                        child: EditBusinessInfoLayout(),
                      ),
                    ));
                  },
                ),
                ActionButton(
                  AppLocalization.of(context).translate("password"),
                  AppLocalization.of(context).translate("password_desc"),
                  () {
                    Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => ChangePasswordBloc(context),
                        child: ChangePasswordLayout(),
                      ),
                    ));
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
