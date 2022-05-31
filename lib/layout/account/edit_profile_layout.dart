import 'package:exservice/bloc/account/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/utils/sizer.dart';
import 'package:exservice/utils/utils.dart';
import 'package:exservice/widget/application/directional_text_field.dart';
import 'package:exservice/widget/application/global_widgets.dart';
import 'package:exservice/widget/bottom_sheets/error_bottom_sheet.dart';
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
  EditProfileBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<EditProfileBloc>(context);
    super.initState();
  }

  void changeProfilePic() async {
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      _bloc.add(EditProfileChangeImageEvent(file));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditProfileBloc, EditProfileState>(
      listenWhen: (_, current) => current is EditProfileErrorState,
      listener: (context, state) {
        if (state is EditProfileErrorState) {
          showErrorBottomSheet(
            context,
            title: AppLocalization.of(context).translate("error"),
            message: Utils.resolveErrorMessage(state.error),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            BlocBuilder<EditProfileBloc, EditProfileState>(
              buildWhen: (_, current) =>
                  current is EditProfileAwaitState ||
                  current is EditProfileAcceptState ||
                  current is EditProfileErrorState,
              builder: (context, state) {
                if (state is EditProfileAwaitState)
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CupertinoActivityIndicator(),
                  );
                return IconButton(
                  splashRadius: 25,
                  icon: Icon(Icons.check),
                  onPressed: () {
                    _bloc.add(EditProfileCommitEvent());
                  },
                );
              },
            )
          ],
        ),
        body: BlocBuilder<EditProfileBloc, EditProfileState>(
          buildWhen: (_, current) =>
              current is EditProfileValidationState ||
              current is EditProfileInitial,
          builder: (context, state) {
            return ListView(
              padding: EdgeInsets.symmetric(
                horizontal: Sizer.hs3,
              ),
              children: <Widget>[
                Center(
                  child: ClipOval(
                    child: OctoImage(
                      height: Sizer.logoSize,
                      width: Sizer.logoSize,
                      fit: BoxFit.cover,
                      image: _bloc.profilePictureProvider,
                      progressIndicatorBuilder: (ctx, _) => simpleShimmer,
                      errorBuilder: (context, e, _) => Container(
                        alignment: Alignment.center,
                        color: AppColors.grayAccent,
                        child: Text(
                          _bloc.profileBloc.model.username,
                        ),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  child: Text(
                    AppLocalization.of(context)
                        .translate("change_profile_photo"),
                  ),
                  onPressed: changeProfilePic,
                ),
                SizedBox(height: Sizer.vs3),
                DirectionalTextField(
                  controller: _bloc.usernameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText:
                        AppLocalization.of(context).translate("username"),
                    errorText: _bloc.usernameErrorMessage?.toString(),
                  ),
                ),
                SizedBox(height: Sizer.vs3),
                DirectionalTextField(
                  controller: _bloc.companyNameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText:
                        AppLocalization.of(context).translate("company_name"),
                    errorText: _bloc.companyNameErrorMessage?.toString(),
                  ),
                ),
                SizedBox(height: Sizer.vs3),
                DirectionalTextField(
                  controller: _bloc.websiteController,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    labelText: AppLocalization.of(context).translate("website"),
                    errorText: _bloc.websiteErrorMessage?.toString(),
                  ),
                ),
                SizedBox(height: Sizer.vs3),
                DirectionalTextField(
                  controller: _bloc.bioController,
                  decoration: InputDecoration(
                    labelText: AppLocalization.of(context).translate("bio"),
                    errorText: _bloc.bioErrorMessage?.toString(),
                  ),
                ),
                SizedBox(height: Sizer.vs1),
              ],
            );
          },
        ),
      ),
    );
  }
}
