import 'dart:async';

import 'package:expandable/expandable.dart';
import 'package:exservice/renovation/bloc/chat/chat_bloc.dart';
import 'package:exservice/renovation/bloc/default/ad_details_bloc/ad_details_bloc.dart';
import 'package:exservice/renovation/bloc/view/account_bloc/account_bloc.dart';
import 'package:exservice/renovation/controller/data_store.dart';
import 'package:exservice/renovation/layout/chat/chat_layout.dart';
import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/styles/app_colors.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:exservice/renovation/utils/constant.dart';
import 'package:exservice/renovation/utils/global.dart';
import 'package:exservice/renovation/utils/utils.dart';
import 'package:exservice/renovation/widget/application/global_widgets.dart';
import 'package:exservice/renovation/widget/application/reload_widget.dart';
import 'package:exservice/renovation/widget/button/app_button.dart';
import 'package:exservice/renovation/widget/button/favorite_button.dart';
import 'package:exservice/renovation/widget/application/app_video.dart';
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        iconTheme: IconThemeData(color: AppColors.blue),
        centerTitle: true,
        title: Text(
          AppLocalization.of(context).trans('app_name'),
          style: AppTextStyle.largeBlack,
        ),
      ),
      body: BlocBuilder<AdDetailsBloc, AdDetailsState>(
        buildWhen: (_, current) =>
            current is AdDetailsErrorState ||
            current is AdDetailsReceivedState ||
            current is AdDetailsAwaitState,
        builder: (context, state) {
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
          if (state is AdDetailsAwaitState) {
            return Center(child: CupertinoActivityIndicator());
          }
          return ListView(
            children: <Widget>[
              getOwnerHeader(),
              AspectRatio(
                aspectRatio: ASPECT_RATIO,
                child: Swiper(
                  itemCount: _bloc.details.media.length,
                  loop: false,
                  curve: Curves.linear,
                  pagination: SwiperPagination(),
                  itemBuilder: (BuildContext context, index) {
                    if (_bloc.details.media[index].type == 1) {
                      return OctoImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(_bloc.details.media[index].link),
                        progressIndicatorBuilder: (context, _) => simpleShimmer,
                        errorBuilder: (context, e, _) => Image.asset(
                          PLACEHOLDER,
                          fit: BoxFit.cover,
                        ),
                      );
                    } else {
                      return Center(
                        child: AppVideo.network(
                          '${_bloc.details.media[index].link}',
                        ),
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Builder(builder: (context) {
                  final content = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          children: [
                            if (_bloc.details.attr.rooms != null)
                              TextSpan(
                                text:
                                    '${_bloc.details.attr.rooms.title} ${AppLocalization.of(context).trans("room")}  ',
                                style: AppTextStyle.mediumBlueBold,
                              ),
                            if (_bloc.details.attr.bath != null)
                              TextSpan(
                                text:
                                    '${_bloc.details.attr.bath.title} ${AppLocalization.of(context).trans("bath")}  ',
                                style: AppTextStyle.mediumBlueBold,
                              ),
                            if (_bloc.details.attr.size != null)
                              TextSpan(
                                text:
                                    '${_bloc.details.attr.size} ${AppLocalization.of(context).trans("meter")}',
                                style: AppTextStyle.mediumBlueBold,
                              ),
                          ],
                        ),
                      ),
                      Text(
                        '${_bloc.details.attr.price} ${_bloc.details.attr.priceOption?.title ?? ""}',
                        textAlign: TextAlign.left,
                        style: AppTextStyle.mediumBlueBold,
                      ),
                      ReadMoreText(
                        _bloc.details.description,
                        style: AppTextStyle.largeBlack,
                        lessStyle: AppTextStyle.smallBlue,
                        moreStyle: AppTextStyle.smallBlue,
                        trimLines: 2,
                        colorClickableText: AppColors.blue,
                        trimMode: TrimMode.Line,
                        trimCollapsedText:
                            AppLocalization.of(context).trans("more"),
                        trimExpandedText:
                            AppLocalization.of(context).trans("less"),
                      ),
                      if (_bloc.details.town != null)
                        Text(
                          "${_bloc.details.town.country}, ${_bloc.details.town.name}",
                          textAlign: TextAlign.left,
                          style: AppTextStyle.mediumGray,
                        ),
                      Text(
                        isoFormatter.format(_bloc.details.createdAt),
                        textAlign: TextAlign.left,
                        style: AppTextStyle.mediumGray,
                      ),
                    ],
                  );
                  if (DataStore.instance.user.id == _bloc.details.owner.id) {
                    return content;
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(child: content),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: BlocBuilder<AdDetailsBloc, AdDetailsState>(
                          buildWhen: (_, current) =>
                              current is UpdateSaveAdDetailsState,
                          builder: (context, state) {
                            return FavoriteButton(
                              active: _bloc.details.saved,
                              onTap: () {
                                _bloc.add(SwitchSaveAdDetailsEvent());
                              },
                            );
                          },
                        ),
                        // child: BookMark(_bloc.details.id, _bloc.details.saved),
                      ),
                    ],
                  );
                }),
              ),
              _getExpandableInfo(),
              if (DataStore.instance.user.id == _bloc.details.owner.id)
                getContactToolbar(),
              SizedBox(height: 10),
            ],
          );
        },
      ),
    );
  }

  Widget getContactToolbar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: AppButton(
              child: Text(
                AppLocalization.of(context).trans('call'),
                style: AppTextStyle.largeBlack,
                textAlign: TextAlign.center,
              ),
              onTap: () {
                if (!Utils.isPhoneNumber(_bloc.details.owner.phoneNumber)) {
                  Fluttertoast.showToast(
                      msg: AppLocalization.of(context)
                          .trans("phone_not_inserted"));
                  return;
                }
                Utils.launchCall(context, _bloc.details.owner.phoneNumber)
                    .catchError((e) => Fluttertoast.showToast(msg: e));
              },
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: AppButton(
              child: Text(
                AppLocalization.of(context).trans('chat'),
                style: AppTextStyle.largeBlack,
                textAlign: TextAlign.center,
              ),
              onTap: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => ChatBloc(
                        BlocProvider.of<AccountBloc>(context).profile.user,
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

  Widget _getExpandableInfo() {
    var details = _bloc.details;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ExpandablePanel(
            collapsed: SizedBox(),
            header: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                AppLocalization.of(context).trans('specifications'),
                style: AppTextStyle.mediumBlack,
              ),
            ),
            expanded: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Builder(builder: (context) {
                final children = <Widget>[
                  Divider(
                    height: 5,
                    color: AppColors.blue,
                  ),
                  SizedBox(height: 5),
                  if (details.attr.option != null)
                    _getFeature(
                      AppLocalization.of(context).trans('option'),
                      details.attr.option.title,
                    ),
                  if (details.attr.category != null)
                    _getFeature(
                      AppLocalization.of(context).trans('type'),
                      details.attr.category.title,
                    ),
                  if (details.attr.furniture != null)
                    _getFeature(
                      AppLocalization.of(context).trans('furniture'),
                      details.attr.furniture.title,
                    ),
                  if (details.attr.balcony != null)
                    _getFeature(
                      AppLocalization.of(context).trans('balcony'),
                      details.attr.balcony.title,
                    ),
                  if (details.attr.garage != null)
                    _getFeature(
                      AppLocalization.of(context).trans('garage'),
                      details.attr.garage.title,
                    ),
                  if (details.attr.terrace != null)
                    _getFeature(
                      AppLocalization.of(context).trans('terrace'),
                      details.attr.terrace.title,
                    ),
                  if (details.attr.gym != null)
                    _getFeature(
                      AppLocalization.of(context).trans('gym'),
                      details.attr.gym.title,
                    ),
                  if (details.attr.security != null)
                    _getFeature(
                      AppLocalization.of(context).trans('security'),
                      details.attr.security.title,
                    ),
                  if (details.createdAt != null)
                    _getFeature(
                      AppLocalization.of(context).trans('createdAt'),
                      isoFormatter.format(details.createdAt),
                    ),
                  if (details.date != null)
                    _getFeature(
                      AppLocalization.of(context).trans('date'),
                      isoFormatter.format(details.date),
                    ),
                ];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: children,
                );
              }),
            ),
          ),
          Divider(
            height: 1,
            color: AppColors.black,
          ),
          SizedBox(
            height: 10,
          ),
          ExpandablePanel(
            collapsed: SizedBox(),
            header: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                AppLocalization.of(context).trans('location'),
                style: AppTextStyle.mediumBlack,
              ),
            ),
            expanded: Builder(builder: (context) {
              if (_bloc.position == null) {
                return SizedBox(
                  height: 100,
                  child: Center(
                    child: Text(
                      AppLocalization.of(context)
                          .trans("location_not_available"),
                      style: AppTextStyle.largeBlack,
                    ),
                  ),
                );
              }
              return Container(
                width: MediaQuery.of(context).size.width,
                height: 170,
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
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _getFeature(String field, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          field,
          style: AppTextStyle.mediumBlack,
        ),
        Text(
          value,
          style: AppTextStyle.mediumBlack,
        )
      ],
    );
  }

  Widget getOwnerHeader() {
    double width = 50;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 15, top: 10, bottom: 10, right: 10),
            width: width,
            height: width,
            decoration: BoxDecoration(
              border: Border.fromBorderSide(
                BorderSide(
                  color: AppColors.blue, // temp condition
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  "${_bloc.details.owner.profilePic}",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _bloc.details.owner.username,
                  textAlign: TextAlign.left,
                  style: AppTextStyle.largeBlackBold,
                ),
                if (_bloc.details.owner.town != null)
                  Text(
                    "${_bloc.details.owner.town.country}, ${_bloc.details.owner.town.name}",
                    textAlign: TextAlign.left,
                    style: AppTextStyle.largeBlack,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
                  "${_bloc.details.totalViews}",
                  style: AppTextStyle.largeBlackBold,
                ),
                Text(
                  AppLocalization.of(context).trans('views'),
                  style: AppTextStyle.largeBlack,
                ),
              ],
            ),
          ),
          //image slider
        ],
      ),
    );
  }
}
