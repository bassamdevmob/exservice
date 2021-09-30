import 'package:exservice/renovation/bloc/account/edit_account_bloc/edit_account_cubit.dart';
import 'package:exservice/renovation/bloc/view/account_bloc/account_bloc.dart';
import 'package:exservice/renovation/layout/account/edit/edit_company_name_layout.dart';
import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/styles/app_colors.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:exservice/renovation/utils/extensions.dart';
import 'package:exservice/renovation/widget/application/global_widgets.dart';
import 'package:exservice/renovation/widget/bottom_sheets/error_bottom_sheet.dart';
import 'package:exservice/ui/personal_account/edit_property/EditBio.dart';
import 'package:exservice/ui/personal_account/edit_property/EditEmail.dart';
import 'package:exservice/ui/personal_account/edit_property/EditPassword.dart';
import 'package:exservice/ui/personal_account/edit_property/EditPhoneNumber.dart';
import 'package:exservice/ui/personal_account/edit_property/EditWebsite.dart';
import 'package:exservice/widget/dialog/ConfirmDialog.dart';
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
          description: AppLocalization.of(dialogContext).trans("changeImage"),
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
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(5),
                        padding: EdgeInsets.all(3),
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.blue),
                        ),
                        child: ClipOval(
                          child: OctoImage(
                            key: ValueKey(user.profilePic),
                            fit: BoxFit.cover,
                            image: NetworkImage(user.profilePic),
                            progressIndicatorBuilder: (context, progress) {
                              return simpleShimmer;
                            },
                            errorBuilder: (context, error, stacktrace) =>
                                Container(
                              color: AppColors.grayAccent,
                              child: Center(
                                child: Text(
                                  user.name.camelCase,
                                  style: AppTextStyle.xxLargeBlack,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        user.name,
                        style: AppTextStyle.largeBlack,
                      ),
                      SizedBox(height: 10),
                      BlocBuilder<AccountBloc, AccountState>(
                        buildWhen: (_, current) =>
                            current is AccountImageState ||
                            current is AccountAwaitImageUploadState ||
                            current is AccountErrorImageUploadState,
                        builder: (context, state) {
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            child: Text(
                              AppLocalization.of(context)
                                  .trans("changeProfilePic"),
                              style: state is AccountAwaitImageUploadState
                                  ? AppTextStyle.largeGray
                                  : AppTextStyle.largeBlue,
                            ),
                            onTap: state is AccountAwaitImageUploadState
                                ? null
                                : changeProfilePic,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                getInfoTile(
                  AppLocalization.of(context).trans('username'),
                  user.name,
                ),
                if (user.type.isCompany) ...[
                  InkWell(
                    onTap: () {
                      //todo update
                      Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => EditAccountCubit(
                            EditAccountCompanyFactory(context),
                          ),
                          child: EditAccountFieldLayout(),
                        ),
                      ));
                    },
                    child: getInfoTile(
                      AppLocalization.of(context).trans('companyName'),
                      user.companyName,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      //todo update
                      // Navigator.of(context).push(CupertinoPageRoute(
                      //   builder: (context) => EditType(),
                      // ));
                    },
                    child: getInfoTile(
                      AppLocalization.of(context).trans('companyType'),
                      user.type.title,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      //todo update
                      Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => EditBio(),
                      ));
                    },
                    child: getInfoTile(
                      AppLocalization.of(context).trans('bio'),
                      user.bio,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      //todo update
                      Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => EditWebsite(),
                      ));
                    },
                    child: getInfoTile(
                      AppLocalization.of(context).trans('website'),
                      user.website,
                    ),
                  ),
                ],
                InkWell(
                  onTap: () {
                    //todo update
                    Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => EditEmail(),
                    ));
                  },
                  child: getInfoTile(
                    AppLocalization.of(context).trans('email2'),
                    user.email,
                  ),
                ),
                InkWell(
                  onTap: () {
                    //todo update
                    Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => EditPhoneNumber(),
                    ));
                  },
                  child: getInfoTile(
                    AppLocalization.of(context).trans('phoneNumber'),
                    user.phoneNumber,
                  ),
                ),
                InkWell(
                  onTap: () {
                    //todo update
                    // Navigator.of(context).push(CupertinoPageRoute(
                    //   builder: (context) => EditLocation(),
                    // ));
                  },
                  child: getInfoTile(
                    AppLocalization.of(context).trans('location'),
                    user.town?.name,
                  ),
                ),
                InkWell(
                  onTap: () {
                    //todo update
                    Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => EditPassword(),
                    ));
                  },
                  child: getInfoTile(
                    AppLocalization.of(context).trans('password'),
                    "********",
                  ),
                ),
              ].withDivider(Divider()),
            );
          },
        ),
      ),
    );
  }
}
