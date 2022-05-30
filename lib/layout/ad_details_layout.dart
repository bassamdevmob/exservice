import 'dart:async';

import 'package:expandable/expandable.dart';
import 'package:exservice/bloc/chat/chat_bloc.dart';
import 'package:exservice/bloc/ad_details_bloc/ad_details_bloc.dart';
import 'package:exservice/bloc/profile_bloc/profile_bloc.dart';
import 'package:exservice/layout/chat/chat_layout.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/utils/constant.dart';
import 'package:exservice/utils/enums.dart';
import 'package:exservice/utils/global.dart';
import 'package:exservice/utils/sizer.dart';
import 'package:exservice/utils/utils.dart';
import 'package:exservice/widget/application/ad_details.dart';
import 'package:exservice/widget/application/global_widgets.dart';
import 'package:exservice/widget/application/reload_widget.dart';
import 'package:exservice/widget/button/favorite_button.dart';
import 'package:exservice/widget/application/app_video.dart';
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
  final Completer<GoogleMapController> _controller = Completer();
  AdDetailsBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<AdDetailsBloc>(context);
    _bloc.add(FetchAdDetailsEvent());
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
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.balcony),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.chat),
              onPressed: () {},
            )
          ],
        ),
        body: BlocBuilder<AdDetailsBloc, AdDetailsState>(
          buildWhen: (_, current) =>
              current is AdDetailsErrorState ||
              current is AdDetailsReceivedState ||
              current is AdDetailsAwaitState,
          builder: (context, state) {
            if (state is AdDetailsAwaitState) {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            }
            if (state is AdDetailsErrorState) {
              return Center(
                child: ReloadWidget.error(
                  content: Text(state.message, textAlign: TextAlign.center),
                  onPressed: () {
                    _bloc.add(FetchAdDetailsEvent());
                  },
                ),
              );
            }
            return ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
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
                              _bloc.details.owner.country,
                              style:
                                  Theme.of(context).primaryTextTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      Column(
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
                      //image slider
                    ],
                  ),
                ),
                AspectRatio(
                  aspectRatio: ASPECT_RATIO,
                  child: Swiper(
                    itemCount: _bloc.details.media.gallery.length,
                    pagination: swiperPagination,
                    itemBuilder: (BuildContext context, index) {
                      if (_bloc.details.media.gallery[index].type ==
                          MediaType.image.name) {
                        return OctoImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              _bloc.details.media.gallery[index].link),
                          progressIndicatorBuilder: (context, _) =>
                              simpleShimmer,
                          errorBuilder: imageErrorBuilder,
                        );
                      } else {
                        return Center(
                          child: AppVideo.network(
                            '${_bloc.details.media.gallery[index].link}',
                          ),
                        );
                      }
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: Sizer.vs3,
                    horizontal: Sizer.vs3,
                  ),
                  child: Column(
                    children: [
                      Builder(builder: (context) {
                        if (BlocProvider.of<ProfileBloc>(context).model.id ==
                            _bloc.details.owner.id) {
                          return AdDetails(_bloc.details);
                        }
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: AdDetails(_bloc.details),
                            ),
                            FavoriteButton(
                              active: _bloc.details.marked,
                              onTap: () {},
                            ),
                          ],
                        );
                      }),
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
                                .translate('specifications'),
                            style:
                                Theme.of(context).primaryTextTheme.bodyMedium,
                          ),
                        ),
                        collapsed: SizedBox(),
                        expanded: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            if (_bloc.details.extra.trade != null)
                              getFeatureWidget(
                                AppLocalization.of(context).translate('option'),
                                "${_bloc.details.extra.trade.type} - ${_bloc.details.extra.trade.flag}",
                              ),
                            if (_bloc.details.extra.type != null)
                              getFeatureWidget(
                                AppLocalization.of(context).translate('type'),
                                "${_bloc.details.extra.type.type} - ${_bloc.details.extra.type.flag}",
                              ),
                            if (_bloc.details.extra.furniture != null)
                              getFeatureWidget(
                                AppLocalization.of(context)
                                    .translate('furniture'),
                                "${_bloc.details.extra.furniture.type} - ${_bloc.details.extra.furniture.flag}",
                              ),
                            if (_bloc.details.extra.balcony != null)
                              getFeatureWidget(
                                AppLocalization.of(context)
                                    .translate('balcony'),
                                "${_bloc.details.extra.balcony.value} ${_bloc.details.extra.balcony.unit}",
                              ),
                            if (_bloc.details.extra.garage != null)
                              getFeatureWidget(
                                AppLocalization.of(context).translate('garage'),
                                "${_bloc.details.extra.garage.value} ${_bloc.details.extra.garage.unit}",
                              ),
                            if (_bloc.details.extra.gym != null)
                              getFeatureWidget(
                                AppLocalization.of(context).translate('gym'),
                                "${_bloc.details.extra.gym.value} ${_bloc.details.extra.gym.unit}",
                              ),
                          ],
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
                                onMapCreated: (GoogleMapController controller) {
                                  _controller.complete(controller);
                                },
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
                      if (BlocProvider.of<ProfileBloc>(context).model.id !=
                          _bloc.details.owner.id)
                        getContactToolbar(),
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

  Widget getContactToolbar() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: Sizer.vs2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              child: Text(
                AppLocalization.of(context).translate('call'),
              ),
              onPressed: () {
                if (!Utils.isPhoneNumber(_bloc.details.owner.phoneNumber)) {
                  Fluttertoast.showToast(
                      msg: AppLocalization.of(context)
                          .translate("phone_not_inserted"));
                  return;
                }
                Utils.launchCall(context, _bloc.details.owner.phoneNumber)
                    .catchError((e) => Fluttertoast.showToast(msg: e));
              },
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              child: Text(
                AppLocalization.of(context).translate('chat'),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => ChatBloc(
                        BlocProvider.of<ProfileBloc>(context).model,
                        _bloc.details.owner,
                      ),
                      child: ChatLayout(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget getFeatureWidget(String field, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          field,
          style: Theme.of(context).primaryTextTheme.bodyMedium,
        ),
        Text(
          value,
          style: Theme.of(context).primaryTextTheme.bodyMedium,
        )
      ],
    );
  }
}
