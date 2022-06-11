import 'package:exservice/bloc/ad_details_bloc/ad_details_bloc.dart';
import 'package:exservice/bloc/chat/chat_bloc.dart';
import 'package:exservice/bloc/publisher_bloc/publisher_cubit.dart';
import 'package:exservice/bloc/profile_bloc/profile_bloc.dart';
import 'package:exservice/layout/ad_details_layout.dart';
import 'package:exservice/layout/chat_layout.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/utils/sizer.dart';
import 'package:exservice/widget/application/ad_details.dart';
import 'package:exservice/widget/application/ad_media.dart';
import 'package:exservice/widget/application/global_widgets.dart';
import 'package:exservice/widget/application/reload_indicator.dart';
import 'package:exservice/widget/bottom_sheets/login_bottom_sheet.dart';
import 'package:exservice/widget/cards/ad_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:octo_image/octo_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:exservice/utils/extensions.dart';

class PublisherLayout extends StatefulWidget {
  @override
  _PublisherLayoutState createState() => _PublisherLayoutState();
}

class _PublisherLayoutState extends State<PublisherLayout> {
  PublisherCubit _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<PublisherCubit>(context);
    _bloc.fetch();
    super.initState();
  }

  Future<void> launchMail() async {
    var email = _bloc.model.email;
    final path = Uri(
      scheme: "mailto",
      path: email,
      queryParameters: {
        "subject": "Hello",
      },
    );
    if (await canLaunchUrl(path)) {
      launchUrl(path);
    } else {
      Fluttertoast.showToast(
        msg: AppLocalization.of(context).translate("cannot_launch"),
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  Future<void> launchCall() async {
    var path = "tel:${_bloc.model.phoneNumber}";
    if (await canLaunchUrlString(path)) {
      launchUrlString(path);
    } else {
      Fluttertoast.showToast(
        msg: AppLocalization.of(context).translate("cannot_launch"),
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  Future<void> launchWeb() async {
    var url = _bloc.model.website;
    if (await canLaunchUrlString(url)) {
      launchUrlString(url);
    } else {
      Fluttertoast.showToast(
        msg: AppLocalization.of(context).translate("cannot_launch"),
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalization.of(context).translate('publisher'),
        ),
      ),
      body: BlocBuilder<PublisherCubit, PublisherState>(
        buildWhen: (_, current) =>
            current is PublisherAwaitState ||
            current is PublisherAcceptState ||
            current is PublisherErrorState,
        builder: (context, state) {
          if (state is PublisherAwaitState) {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }
          if (state is PublisherErrorState) {
            return Center(
              child: ReloadIndicator(
                error: state.error,
                onTap: () {
                  _bloc.fetch();
                },
              ),
            );
          }
          return SmartRefresher(
            controller: _bloc.refreshController,
            enablePullDown: false,
            onLoading: () => _bloc.loadMore(),
            enablePullUp: _bloc.enablePullUp,
            footer: ClassicFooter(
              onClick: () {
                if (_bloc.refreshController.footerStatus == LoadStatus.failed) {
                  _bloc.refreshController.requestLoading();
                }
              },
            ),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      getHeader(),
                      SizedBox(height: 5),
                      Text(
                        _bloc.model.email,
                        style: Theme.of(context).primaryTextTheme.bodySmall,
                      ),
                      SizedBox(height: 5),
                      Text(
                        _bloc.model.phoneNumber,
                        style: Theme.of(context).primaryTextTheme.bodySmall,
                      ),
                      SizedBox(height: 5),
                      if (_bloc.model.website != null)
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: GestureDetector(
                            child: Text(
                              _bloc.model.website,
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .titleSmall
                                  .copyWith(color: AppColors.blueAccent),
                            ),
                            onTap: () {
                              launchWeb();
                            },
                          ),
                        ),
                      SizedBox(height: 5),
                      if (_bloc.model.bio != null)
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            _bloc.model.bio,
                            style:
                                Theme.of(context).primaryTextTheme.bodyMedium,
                          ),
                        ),
                      SizedBox(height: Sizer.vs2),
                      getContactToolbar(),
                      SizedBox(height: Sizer.vs2),
                    ]),
                  ),
                ),
                BlocBuilder<PublisherCubit, PublisherState>(
                  buildWhen: (_, current) => current is PublisherAdsAcceptState,
                  builder: (context, state) {
                    if (state is PublisherAdsAcceptState) {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            var model = _bloc.ads[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      CupertinoPageRoute(
                                        builder: (context) => BlocProvider(
                                          create: (context) => AdDetailsBloc(
                                            model.id,
                                            locator: context.read,
                                          ),
                                          child: AdDetailsLayout(),
                                        ),
                                      ),
                                    );
                                  },
                                  child: AdGallery(model),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: Sizer.vs3,
                                    horizontal: Sizer.vs3,
                                  ),
                                  child: AdDetails(model),
                                ),
                                Divider(color: AppColors.deepGray),
                              ],
                            );
                          },
                          childCount: _bloc.ads.length,
                        ),
                      );
                    }
                    return SliverPadding(
                      padding: EdgeInsets.all(Sizer.hs1),
                      sliver: SliverToBoxAdapter(
                        child: CupertinoActivityIndicator(),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget getHeader() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
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
            SizedBox(height: Sizer.vs3),
            Text(
              _bloc.model.username,
              style: Theme.of(context).primaryTextTheme.bodySmall,
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
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

  // Widget getHeader() {
  //   return Row(
  //     mainAxisSize: MainAxisSize.min,
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: <Widget>[
  //       Padding(
  //         padding: const EdgeInsets.all(10),
  //         child: ClipOval(
  //           child: OctoImage(
  //             width: Sizer.avatarSizeLarge,
  //             height: Sizer.avatarSizeLarge,
  //             fit: BoxFit.cover,
  //             image: NetworkImage(_bloc.model.profilePicture),
  //             progressIndicatorBuilder: (context, progress) => simpleShimmer,
  //             errorBuilder: imageErrorBuilder,
  //           ),
  //         ),
  //       ),
  //       SizedBox(width: 10),
  //       Expanded(
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.stretch,
  //           children: <Widget>[
  //             Text(
  //               _bloc.model.username,
  //               style: Theme.of(context).primaryTextTheme.bodyMedium,
  //               maxLines: 1,
  //             ),
  //             Text(
  //               "${_bloc.model.location.country} ${_bloc.model.location.city}",
  //               style: Theme.of(context).primaryTextTheme.bodyMedium,
  //               maxLines: 1,
  //             )
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget getContactToolbar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        if (_bloc.model.phoneNumber != null)
          OutlinedButton(
            child: Text(
              AppLocalization.of(context).translate("call"),
            ),
            onPressed: launchCall,
          ),
        OutlinedButton(
          child: Text(
            AppLocalization.of(context).translate("chat"),
          ),
          onPressed: () {
            if (context.read<ProfileBloc>().isAuthenticated) {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => ChatBloc(
                      BlocProvider.of<ProfileBloc>(context).model,
                      _bloc.model,
                    ),
                    child: ChatLayout(),
                  ),
                ),
              );
            } else {
              LoginBottomSheet.show(context);
            }
          },
        ),
        if (_bloc.model.email != null)
          OutlinedButton(
            child: Text(
              AppLocalization.of(context).translate("mail"),
            ),
            onPressed: launchMail,
          ),
      ],
    );
  }

  Widget getBody() {
    return SizedBox();
  }
}
