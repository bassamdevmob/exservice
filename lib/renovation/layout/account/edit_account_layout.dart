import 'package:exservice/renovation/bloc/account/business_info_bloc/business_info_bloc.dart';
import 'package:exservice/renovation/bloc/account/change_password_bloc/change_password_bloc.dart';
import 'package:exservice/renovation/bloc/view/account_bloc/account_bloc.dart';
import 'package:exservice/renovation/layout/account/edit/change_password_layout.dart';
import 'package:exservice/renovation/layout/account/contact_info_layout.dart';
import 'package:exservice/renovation/layout/account/edit/edit_business_info_layout.dart';
import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/styles/app_colors.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:exservice/renovation/utils/extensions.dart';
import 'package:exservice/renovation/widget/application/dotted_container.dart';
import 'package:exservice/renovation/widget/application/global_widgets.dart';
import 'package:exservice/renovation/widget/bottom_sheets/error_bottom_sheet.dart';
import 'package:exservice/renovation/widget/button/action_button.dart';
import 'package:exservice/renovation/widget/dialogs/confirm_dialog.dart';
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
  AccountBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<AccountBloc>(context);
    super.initState();
  }

  void changeProfilePic() async {
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      showDialog(
        context: context,
        builder: (dialogContext) => ConfirmDialog(
          mediaPath: file.path,
          text: AppLocalization.of(dialogContext).trans("changeImage"),
          onTap: () {
            Navigator.of(dialogContext).pop();
            _bloc.add(AccountChangeProfileImageEvent(file.path));
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
                  AppLocalization.of(context).trans("notAssigned"),
                  style: AppTextStyle.largeGray,
                )
              : Text(val, style: AppTextStyle.largeBlackBold),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var user = context.read<AccountBloc>().profile.user;
    return BlocListener<AccountBloc, AccountState>(
      listenWhen: (_, current) => current is AccountErrorImageUploadState,
      listener: (context, state) {
        if (state is AccountErrorImageUploadState) {
          showErrorBottomSheet(
            context,
            AppLocalization.of(context).trans("error"),
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
            AppLocalization.of(context).trans("app_name"),
            style: AppTextStyle.largeLobsterBlack,
          ),
        ),
        body: BlocBuilder<AccountBloc, AccountState>(
          buildWhen: (_, current) => current is AccountInitial,
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
                                key: ValueKey(user.profilePic),
                                fit: BoxFit.cover,
                                image: NetworkImage(user.profilePic),
                                progressIndicatorBuilder: (context, progress) {
                                  return simpleShimmer;
                                },
                                errorBuilder: (context, e, _) => Container(
                                  alignment: Alignment.center,
                                  color: AppColors.grayAccent,
                                  child: Text(
                                    user.username.camelCase,
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
                          child: BlocBuilder<AccountBloc, AccountState>(
                            buildWhen: (_, current) =>
                                current is AccountImageState ||
                                current is AccountAwaitImageUploadState ||
                                current is AccountErrorImageUploadState,
                            builder: (context, state) {
                              return MaterialButton(
                                color: state is AccountAwaitImageUploadState
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
                                onPressed: state is AccountAwaitImageUploadState
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
                  AppLocalization.of(context).trans("contact_info"),
                  AppLocalization.of(context).trans("contact_info_desc"),
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
                if (user.type.isCompany)
                  ActionButton(
                    AppLocalization.of(context).trans("business_info"),
                    AppLocalization.of(context).trans("business_info_desc"),
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
                  AppLocalization.of(context).trans("password"),
                  AppLocalization.of(context).trans("password_desc"),
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
