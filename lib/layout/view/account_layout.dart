import 'package:exservice/bloc/account/account_ads_bloc/account_ads_cubit.dart';
import 'package:exservice/bloc/profile_bloc/profile_bloc.dart';
import 'package:exservice/layout/account/account_ads_layout.dart';
import 'package:exservice/layout/account/edit_account_layout.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/utils/enums.dart';
import 'package:exservice/utils/extensions.dart';
import 'package:exservice/utils/sizer.dart';
import 'package:exservice/widget/application/global_widgets.dart';
import 'package:exservice/widget/application/reload_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octo_image/octo_image.dart';

class AccountLayout extends StatefulWidget {
  @override
  _AccountLayoutState createState() => _AccountLayoutState();
}

class _AccountLayoutState extends State<AccountLayout> {
  ProfileBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<ProfileBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (_, current) =>
          current is ProfileInitial ||
          current is ProfileAwaitState ||
          current is ProfileAcceptState ||
          current is ProfileErrorState,
      builder: (context, state) {
        if (state is ProfileAwaitState) {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        }
        if (state is ProfileErrorState) {
          return Center(
            child: ReloadIndicator(
              error: state.error,
              onTap: () {
                _bloc.add(ProfileFetchEvent());
              },
            ),
          );
        }
        return ListView(
          children: [
            getHeader(),
            SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Sizer.hs2,
              ),
              child: Text(
                _bloc.model.email,
                style: Theme.of(context).primaryTextTheme.bodySmall,
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Sizer.hs2,
              ),
              child: Text(
                _bloc.model.phoneNumber,
                style: Theme.of(context).primaryTextTheme.bodySmall,
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Sizer.hs3,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OutlinedButton(
                    child: Text(
                      AppLocalization.of(context).translate('edit'),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => EditAccountLayout(),
                      ));
                    },
                  ),
                  SizedBox(height: Sizer.vs3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => AccountAdsCubit(AdStatus.active),
                                child: AccountAdsLayout(),
                              ),
                            ),
                          );
                        },
                        child: Icon(Icons.motion_photos_on),
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => AccountAdsCubit(AdStatus.paused),
                                child: AccountAdsLayout(),
                              ),
                            ),
                          );
                        },
                        child: Icon(Icons.motion_photos_pause),
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) =>
                                    AccountAdsCubit(AdStatus.expired),
                                child: AccountAdsLayout(),
                              ),
                            ),
                          );
                        },
                        child: Icon(Icons.motion_photos_off),
                      ),
                    ],
                  ),
                  SizedBox(height: Sizer.vs3),
                  getInfoTile(
                    AppLocalization.of(context).translate("companyName"),
                    _bloc.model.companyName,
                  ),
                  SizedBox(height: Sizer.vs3),
                  getInfoTile(
                    AppLocalization.of(context).translate("website"),
                    _bloc.model.website,
                  ),
                  SizedBox(height: Sizer.vs3),
                  getInfoTile(
                    AppLocalization.of(context).translate("location"),
                    "${_bloc.model.location.country} ${_bloc.model.location.city}",
                  ),
                  SizedBox(height: Sizer.vs3),
                  getInfoTile(
                    AppLocalization.of(context).translate("desc"),
                    _bloc.model.bio,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget getHeader() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Sizer.hs2,
          ),
          child: Column(
            children: <Widget>[
              ClipOval(
                child: OctoImage(
                  width: Sizer.avatarSizeLarge,
                  height: Sizer.avatarSizeLarge,
                  fit: BoxFit.cover,
                  image: NetworkImage(_bloc.model.profilePicture),
                  progressIndicatorBuilder: (context, _) => simpleShimmer,
                  errorBuilder: (context, e, _) => Container(
                    color: AppColors.grayAccent,
                    child: Center(
                      child: Text(
                        _bloc.model.username.camelCase,
                        style: Theme.of(context).primaryTextTheme.titleLarge,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                _bloc.model.username,
                style: Theme.of(context).primaryTextTheme.bodySmall,
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        ),
        Spacer(),
        getStatusItem(
          "${_bloc.model.statistics.activeAdsCount}",
          AppLocalization.of(context).translate('active'),
        ),
        Spacer(),
        getStatusItem(
          "${_bloc.model.statistics.inactiveAdsCount}",
          AppLocalization.of(context).translate('inactive'),
        ),
        Spacer(),
        getStatusItem(
          "${_bloc.model.statistics.expiredAdsCount}",
          AppLocalization.of(context).translate('expired'),
        ),
        Spacer(),
      ],
    );
  }

  Widget getStatusItem(String number, String title) {
    return Column(
      children: <Widget>[
        Text(
          number,
          style: Theme.of(context).primaryTextTheme.bodySmall,
        ),
        Text(
          title,
          style: Theme.of(context).primaryTextTheme.bodySmall,
        ),
      ],
    );
  }

  Widget getInfoTile(String key, String val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          key,
          style: Theme.of(context).primaryTextTheme.titleMedium,
        ),
        Text(
          val,
          style: Theme.of(context).primaryTextTheme.bodyMedium,
        ),
      ],
    );
  }
}
