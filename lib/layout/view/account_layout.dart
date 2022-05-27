import 'package:exservice/bloc/account/account_ads_bloc/account_ads_cubit.dart';
import 'package:exservice/bloc/profile_bloc/profile_bloc.dart';
import 'package:exservice/layout/account/account_ads_layout.dart';
import 'package:exservice/layout/account/edit_account_layout.dart';
import 'package:exservice/layout/account/welcome_business_layout.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:exservice/utils/enums.dart';
import 'package:exservice/utils/extensions.dart';
import 'package:exservice/widget/application/animated_avatar.dart';
import 'package:exservice/widget/application/company_video.dart';
import 'package:exservice/widget/application/dotted_container.dart';
import 'package:exservice/widget/application/global_widgets.dart';
import 'package:exservice/widget/application/reload_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octo_image/octo_image.dart';

class AccountLayout extends StatefulWidget {
  static final name = "account";

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
          current is ProfileAccessibleState ||
          current is ProfileErrorState,
      builder: (context, state) {
        if (state is ProfileErrorState) {
          return Center(
            child: ReloadWidget.error(
              content: Text(state.message, textAlign: TextAlign.center),
              onPressed: () {
                _bloc.add(ProfileFetchEvent());
              },
            ),
          );
        }
        if (state is ProfileAwaitState) {
          return Center(child: CupertinoActivityIndicator());
        }
        return WillPopScope(
          onWillPop: () async {
            if (!_bloc.scrollController.hasClients ||
                _bloc.scrollController.offset == 0) {
              return true;
            } else {
              _bloc.scrollController.animateTo(
                0,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeOut,
              );
              return false;
            }
          },
          child: Builder(builder: (context) {
            final scrollView = NestedScrollView(
              controller: _bloc.scrollController,
              headerSliverBuilder: (context, _) {
                return [
                  SliverList(
                      delegate: SliverChildListDelegate([
                    getHeader(),
                    Divider(),
                  ])),
                ];
              },
              body: Column(
                children: <Widget>[
                  getTabBar(),
                  Divider(),
                  Expanded(
                    child: BlocBuilder<ProfileBloc, ProfileState>(
                      buildWhen: (_, current) =>
                          current is ProfileChangeTabState,
                      builder: (context, state) {
                        switch (_bloc.currentTab) {
                          case ProfileTab.details:
                            return getProfileInformation();
                          default:
                            return getProfileAdvertisements();
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
            if (_bloc.model.type == UserType.BUSINESS.name) {
              return scrollView;
            }

            return Column(
              children: <Widget>[
                Expanded(
                  child: scrollView,
                ),
                Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => WelcomeBusinessLayout(),
                        ),
                      );
                    },
                    child: Text(
                      AppLocalization.of(context).translate('stb'),
                      style: AppTextStyle.largeBlue,
                    ),
                  ),
                ),
              ],
            );
          }),
        );
      },
    );
  }

  Widget getProfileAdvertisements() {
    return ListView(
      children: <Widget>[
        getActionButton(AppLocalization.of(context).translate('activeAds'), () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => AccountAdsCubit(AdStatus.active),
                child: AccountAdsLayout(),
              ),
            ),
          );
        }),
        Divider(),
        getActionButton(AppLocalization.of(context).translate('nonActiveAds'), () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => AccountAdsCubit(AdStatus.paused),
                child: AccountAdsLayout(),
              ),
            ),
          );
        }),
        Divider(),
        getActionButton(AppLocalization.of(context).translate('expired'), () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => AccountAdsCubit(AdStatus.expired),
                child: AccountAdsLayout(),
              ),
            ),
          );
        }),
        Divider(),
      ],
    );
  }

  Widget getProfileInformation() {
    return ListView(
      children: <Widget>[
        getInfoTile(
          AppLocalization.of(context).translate("username"),
          _bloc.model.username,
        ),
        getInfoTile(
          AppLocalization.of(context).translate("email2"),
          _bloc.model.email,
        ),
        getInfoTile(
          AppLocalization.of(context).translate("phoneNumber"),
          _bloc.model.phoneNumber,
        ),
        if (_bloc.model.type == UserType.BUSINESS.name) ...[
          getInfoTile(
            AppLocalization.of(context).translate("companyName"),
            _bloc.model.business.companyName,
          ),
          getInfoTile(
            AppLocalization.of(context).translate("website"),
            _bloc.model.business.website,
          ),
          getInfoTile(
            AppLocalization.of(context).translate("phone_number"),
            _bloc.model.business.publicPhone,
          ),
          getInfoTile(
            AppLocalization.of(context).translate("location"),
            _bloc.model.country,
          ),
          getInfoTile(
            AppLocalization.of(context).translate("desc"),
            _bloc.model.business.bio,
          ),
          CompanyVideo(),
        ],
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              child: Text(
                AppLocalization.of(context).translate('edit'),
                style: AppTextStyle.mediumWhite,
              ),
              onPressed: () {
                //todo refresh page
                Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => EditAccountLayout(),
                ));
              },
            ),
          ),
        )
      ].withDivider(Divider()),
      padding: EdgeInsets.only(bottom: 20),
    );
  }

  Widget getActionButton(String text, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [AppColors.blue, AppColors.deepPurple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      title: Text(text, style: AppTextStyle.largeBlack),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }

  Widget getHeader() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: <Widget>[
                OutlineContainer(
                  dimension: 70,
                  radius: 35,
                  strokeWidth: 1,
                  gradient: LinearGradient(
                    colors: [AppColors.blue, AppColors.deepPurple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  child: ClipOval(
                    child: OctoImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(_bloc.model.profilePicture),
                      progressIndicatorBuilder: (context, _) => simpleShimmer,
                      errorBuilder: (context, e, _) => Container(
                        color: AppColors.grayAccent,
                        child: Center(
                          child: Text(
                            _bloc.model.username.camelCase,
                            style: AppTextStyle.xxLargeBlack,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  _bloc.model.username,
                  style: AppTextStyle.largeBlack,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              getStatusItem(
                "${_bloc.model.statistics.activeAdsCount}",
                AppLocalization.of(context).translate('active'),
              ),
              getStatusItem(
                "${_bloc.model.statistics.inactiveAdsCount}",
                AppLocalization.of(context).translate('inactive'),
              ),
              getStatusItem(
                "${_bloc.model.statistics.expiredAdsCount}",
                AppLocalization.of(context).translate('expired'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget getStatusItem(String number, String title) {
    return Column(
      children: <Widget>[
        Text(number, style: AppTextStyle.mediumBlack),
        Text(title, style: AppTextStyle.mediumBlack),
      ],
    );
  }

  Widget getSelector(String title, ProfileTab tab) {
    return AnimatedAvatar(
      text: title,
      checked: _bloc.currentTab == tab,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      size: 50,
      image: Container(
        color: AppColors.grayAccent,
        child: Center(
          child: Text(
            title.firstCapLetter,
            style: AppTextStyle.xxLargeBlack,
          ),
        ),
      ),
      onTap: () {
        _bloc.add(ProfileChangeTabEvent(tab));
      },
    );
  }

  Widget getTabBar() {
    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (_, current) => current is ProfileChangeTabState,
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            getSelector(
              AppLocalization.of(context).translate('account'),
              ProfileTab.details,
            ),
            getSelector(
              AppLocalization.of(context).translate('myAds'),
              ProfileTab.advertisements,
            ),
          ],
        );
      },
    );
  }

  Widget getInfoTile(String key, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            key,
            style: AppTextStyle.mediumBlack,
          ),
          val == null
              ? Text(
                  AppLocalization.of(context).translate("notAssigned"),
                  style: AppTextStyle.largeGray,
                )
              : Text(
                  val,
                  style: AppTextStyle.largeBlackBold,
                ),
        ],
      ),
    );
  }
}
