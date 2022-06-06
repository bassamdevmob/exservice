import 'package:expandable/expandable.dart';
import 'package:exservice/bloc/ad_details_bloc/ad_details_bloc.dart';
import 'package:exservice/bloc/edit_ad_bloc/edit_ad_bloc.dart';
import 'package:exservice/layout/edit_ad_layout.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/utils/constant.dart';
import 'package:exservice/utils/enums.dart';
import 'package:exservice/utils/global.dart';
import 'package:exservice/utils/sizer.dart';
import 'package:exservice/utils/utils.dart';
import 'package:exservice/widget/application/ad_details.dart';
import 'package:exservice/widget/application/global_widgets.dart';
import 'package:exservice/widget/application/reload_indicator.dart';
import 'package:exservice/widget/application/status_container.dart';
import 'package:exservice/widget/bottom_sheets/delete_bottom_sheet.dart';
import 'package:exservice/widget/bottom_sheets/error_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:octo_image/octo_image.dart';
import 'package:readmore/readmore.dart';

class AdDetailsLayout extends StatefulWidget {
  const AdDetailsLayout({Key key}) : super(key: key);

  @override
  _AdDetailsLayoutState createState() => _AdDetailsLayoutState();
}

class _AdDetailsLayoutState extends State<AdDetailsLayout> {
  AdDetailsBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<AdDetailsBloc>(context);
    _bloc.add(AdDetailsFetchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableTheme(
      data: ExpandableThemeData(
        iconColor: Theme.of(context).iconTheme.color,
        headerAlignment: ExpandablePanelHeaderAlignment.center,
      ),
      child: Scaffold(
        appBar: AppBar(),
        body: BlocConsumer<AdDetailsBloc, AdDetailsState>(
          listener: (context, state) {
            if (state is AdDetailsDeleteErrorState) {
              showErrorBottomSheet(
                context,
                title: AppLocalization.of(context).translate("error"),
                message: Utils.resolveErrorMessage(state.error),
              );
            } else if (state is AdDetailsStatusErrorState) {
              showErrorBottomSheet(
                context,
                title: AppLocalization.of(context).translate("error"),
                message: Utils.resolveErrorMessage(state.error),
              );
            } else if (state is AdDetailsDeleteAcceptState) {
              Fluttertoast.showToast(
                msg: state.message,
                toastLength: Toast.LENGTH_LONG,
              );
              if (mounted) Navigator.of(context).pop();
            } else if (state is AdDetailsStatusAcceptState) {
              Fluttertoast.showToast(
                msg: state.message,
                toastLength: Toast.LENGTH_LONG,
              );
            }
          },
          buildWhen: (_, current) =>
              current is AdDetailsErrorState ||
              current is AdDetailsAcceptState ||
              current is AdDetailsAwaitState,
          builder: (context, state) {
            if (state is AdDetailsAwaitState) {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            }
            if (state is AdDetailsErrorState) {
              return Center(
                child: ReloadIndicator(
                  error: state.error,
                  onTap: () {
                    _bloc.add(AdDetailsFetchEvent());
                  },
                ),
              );
            }
            return ListView(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Sizer.hs3,
                        vertical: Sizer.vs3,
                      ),
                      child: ClipOval(
                        child: OctoImage(
                          width: Sizer.avatarSizeLarge,
                          height: Sizer.avatarSizeLarge,
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            _bloc.details.owner.profilePicture,
                          ),
                          progressIndicatorBuilder: (ctx, _) => simpleShimmer,
                          errorBuilder: imageErrorBuilder,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _bloc.details.owner.username,
                            style:
                                Theme.of(context).primaryTextTheme.bodyMedium,
                          ),
                          Text(
                            "${_bloc.details.owner.location.country} ${_bloc.details.owner.location.city}",
                            style:
                                Theme.of(context).primaryTextTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            _bloc.details.views.toString(),
                            style: Theme.of(context).primaryTextTheme.bodySmall,
                          ),
                          Text(
                            AppLocalization.of(context).translate('views'),
                            style:
                                Theme.of(context).primaryTextTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                    //image slider
                  ],
                ),
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: ASPECT_RATIO,
                      child: Swiper(
                        itemCount: _bloc.details.media.length,
                        pagination: swiperPagination,
                        itemBuilder: (BuildContext context, index) {
                          return OctoImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              _bloc.details.media[index].link,
                            ),
                            progressIndicatorBuilder: (context, _) =>
                                simpleShimmer,
                            errorBuilder: imageErrorBuilder,
                          );
                        },
                      ),
                    ),
                    if (_bloc.isOwned)
                      BlocBuilder<AdDetailsBloc, AdDetailsState>(
                        buildWhen: (_, current) =>
                            current is AdDetailsStatusAcceptState,
                        builder: (context, state) {
                          return StatusContainer(_bloc.details.status);
                        },
                      ),
                  ],
                ),
                if (_bloc.isOwned) getControlButtons(),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: Sizer.vs3,
                    horizontal: Sizer.vs3,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: AdDetails(_bloc.details),
                          ),
                          if (!_bloc.isOwned) getBookmarkButton(),
                        ],
                      ),
                      SizedBox(
                        height: Sizer.vs2,
                      ),
                      ReadMoreText(
                        _bloc.details.description,
                        style: Theme.of(context).primaryTextTheme.bodySmall,
                        lessStyle:
                            Theme.of(context).primaryTextTheme.titleSmall,
                        moreStyle:
                            Theme.of(context).primaryTextTheme.titleSmall,
                        trimLines: 2,
                        colorClickableText: AppColors.blue,
                        trimMode: TrimMode.Line,
                        trimCollapsedText:
                            AppLocalization.of(context).translate("more"),
                        trimExpandedText:
                            AppLocalization.of(context).translate("less"),
                      ),
                      SizedBox(height: Sizer.vs2),
                      ExpandablePanel(
                        header: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            AppLocalization.of(context)
                                .translate('more_details'),
                            style:
                                Theme.of(context).primaryTextTheme.bodyMedium,
                          ),
                        ),
                        collapsed: SizedBox(),
                        expanded: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: List.generate(
                            _bloc.details.extra.length,
                            (index) => Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.arrow_right,
                                  size: 20,
                                ),
                                Expanded(
                                  child: Text(
                                    _bloc.details.extra[index],
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Divider(),
                      if (_bloc.position != null)
                        ExpandablePanel(
                          header: Text(
                            AppLocalization.of(context).translate('location'),
                            style:
                                Theme.of(context).primaryTextTheme.bodyMedium,
                          ),
                          collapsed: SizedBox(),
                          expanded: AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              child: GoogleMap(
                                key: UniqueKey(),
                                rotateGesturesEnabled: false,
                                scrollGesturesEnabled: false,
                                zoomGesturesEnabled: false,
                                initialCameraPosition: CameraPosition(
                                  target: _bloc.position,
                                  zoom: 12.0,
                                ),
                                mapType: MapType.normal,
                                markers: Set.from([
                                  Marker(
                                    markerId: MarkerId('0'),
                                    position: _bloc.position,
                                  ),
                                ]),
                              ),
                            ),
                          ),
                        ),
                      SizedBox(height: Sizer.vs2),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget getBookmarkButton() {
    return BlocBuilder<AdDetailsBloc, AdDetailsState>(
      buildWhen: (_, current) =>
          current is AdDetailsBookmarkErrorState ||
          current is AdDetailsBookmarkAcceptState ||
          current is AdDetailsBookmarkAwaitState,
      builder: (context, state) {
        var color = Theme.of(context).iconTheme.color;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _bloc.mode == DisplayMode.review ||
                  state is AdDetailsBookmarkAwaitState
              ? null
              : () {
                  _bloc.add(AdDetailsBookmarkEvent());
                },
          child: Icon(
            _bloc.details.marked ? Icons.bookmark : Icons.bookmark_outline,
            size: 25,
            color: state is AdDetailsBookmarkAwaitState
                ? color.withOpacity(0.5)
                : color,
          ),
        );
      },
    );
  }

  Widget getControlButtons() {
    return Padding(
      padding: EdgeInsets.only(top: Sizer.vs3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          OutlinedButton(
            child: Text(
              AppLocalization.of(context).translate("edit"),
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(CupertinoPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => EditAdBloc(_bloc.details),
                  child: EditAdLayout(),
                ),
              ))
                  .whenComplete(() {
                _bloc.add(AdDetailsUpdateEvent());
              });
            },
          ),
          Builder(
            builder: (context) {
              if (_bloc.details.status == AdStatus.expired.name) {
                return Text(
                  AppLocalization.of(context).translate("expired"),
                  style: Theme.of(context).primaryTextTheme.bodyMedium,
                );
              } else {
                return BlocBuilder<AdDetailsBloc, AdDetailsState>(
                  buildWhen: (_, current) =>
                      current is AdDetailsStatusAwaitState ||
                      current is AdDetailsStatusAcceptState ||
                      current is AdDetailsStatusErrorState,
                  builder: (context, state) {
                    return OutlinedButton(
                      child: state is AdDetailsStatusAwaitState
                          ? CupertinoActivityIndicator()
                          : Text(
                              AdStatus.paused.name == _bloc.details.status
                                  ? AppLocalization.of(context)
                                      .translate("activate")
                                  : AppLocalization.of(context)
                                      .translate("pause"),
                            ),
                      onPressed: state is AdDetailsStatusAwaitState
                          ? null
                          : () {
                              if (AdStatus.paused.name == _bloc.details.status)
                                _bloc.add(AdDetailsActivateEvent());
                              else
                                _bloc.add(AdDetailsPauseEvent());
                            },
                    );
                  },
                );
              }
            },
          ),
          BlocBuilder<AdDetailsBloc, AdDetailsState>(
            buildWhen: (_, current) =>
                current is AdDetailsDeleteAwaitState ||
                current is AdDetailsDeleteAcceptState ||
                current is AdDetailsDeleteErrorState,
            builder: (context, state) {
              return OutlinedButton(
                style: OutlinedButton.styleFrom(
                  primary: AppColors.red,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 5.0, color: Colors.blue),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: state is AdDetailsDeleteAwaitState
                    ? CupertinoActivityIndicator()
                    : Text(
                        AppLocalization.of(context).translate("delete"),
                      ),
                onPressed: state is AdDetailsDeleteAwaitState
                    ? null
                    : () {
                        DeleteBottomSheet.show(context, onTap: () {
                          _bloc.add(AdDetailsDeleteEvent());
                        });
                      },
              );
            },
          ),
        ],
      ),
    );
  }

//
//   _activate() {
//     showDialog(
//       context: context,
//       builder: (ctx) => ConfirmDialog(
//         text: AppLocalization.of(context).translate("confirmActivate"),
//         onTap: () {
//           Navigator.of(ctx).pop();
//           setState(() => statusLoading = true);
//           _bloc.activateAd(widget.ad).then((_) {
//             _accountBloc.model.statistics.activeAdsCount++;
//             _accountBloc.model.statistics.inactiveAdsCount--;
//             _accountBloc.add(ProfileRefreshEvent());
//             Fluttertoast.showToast(
//               msg: AppLocalization.of(context).translate("activated"),
//             );
//           }).catchError((e) {
//             showErrorBottomSheet(
//               context,
//               title: AppLocalization.of(context).translate("error"),
//               message: "$e",
//             );
//           }).whenComplete(() {
//             setState(() => statusLoading = false);
//           });
//         },
//       ),
//     );
//   }
//
//   _pause() {
//     showDialog(
//       context: context,
//       builder: (ctx) => ConfirmDialog(
//         text: AppLocalization.of(context).translate("confirmPause"),
//         onTap: () {
//           Navigator.of(ctx).pop();
//           setState(() => statusLoading = true);
//           _bloc.pauseAd(widget.ad).then((_) {
//             _accountBloc.model.statistics.activeAdsCount--;
//             _accountBloc.model.statistics.inactiveAdsCount++;
//             _accountBloc.add(ProfileRefreshEvent());
//             Fluttertoast.showToast(
//               msg: AppLocalization.of(context).translate("paused"),
//             );
//           }).catchError((e) {
//             showErrorBottomSheet(
//               context,
//               title: AppLocalization.of(context).translate("error"),
//               message: "$e",
//             );
//           }).whenComplete(() {
//             setState(() => statusLoading = false);
//           });
//         },
//       ),
//     );
//   }
}
