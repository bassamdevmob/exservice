import 'dart:typed_data';

import 'package:badges/badges.dart';
import 'package:exservice/bloc/view/post_ad_bloc/post_ad_bloc.dart';
import 'package:exservice/layout/post/post_ad_details_layout.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/styles/app_font_size.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:exservice/utils/global.dart';
import 'package:exservice/utils/utils.dart';
import 'package:exservice/widget/application/animated_cross_icon.dart';
import 'package:exservice/widget/application/global_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sliver_tools/sliver_tools.dart';

class PostAdLayout extends StatefulWidget {
  @override
  _PostAdLayoutState createState() => _PostAdLayoutState();
}

class _PostAdLayoutState extends State<PostAdLayout> {
  PostAdBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<PostAdBloc>(context);
    _bloc.add(FetchPostAdEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostAdBloc, PostAdState>(
      listenWhen: (_, current) =>
          current is PostAdReachedMediaMaxLimitsErrorState,
      listener: (context, state) {
        if (state is PostAdReachedMediaMaxLimitsErrorState) {
          Fluttertoast.showToast(
            msg: AppLocalization.of(context)
                .translate("reached_max_media_limits"),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalization.of(context).translate('post'),
          ),
          actions: [
            Center(
              child: getNextButton(),
            ),
          ],
        ),
        body: BlocBuilder<PostAdBloc, PostAdState>(
          buildWhen: (_, current) =>
              current is PostAdAwaitState ||
              current is PostAdAcceptState ||
              current is PostAdSelectMediaState,
          builder: (context, state) {
            if (state is PostAdAwaitState) {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            }
            return NestedScrollView(
              headerSliverBuilder: (context, _) {
                return [
                  SliverStack(
                    children: [
                      SliverToBoxAdapter(
                        child: AspectRatio(
                          aspectRatio: ratios.first.value,
                          child: getSlider(),
                        ),
                      ),
                      SliverPositioned.directional(
                        bottom: 20,
                        start: 20,
                        textDirection: Directionality.of(context),
                        child: BlocBuilder<PostAdBloc, PostAdState>(
                          buildWhen: (_, current) =>
                              current is PostAdChangeDisplayModeState,
                          builder: (context, state) {
                            return GestureDetector(
                              onTap: () {
                                _bloc.add(ChangeDisplayModePostAdEvent());
                              },
                              child: AnimatedCrossIcon(
                                startIcon: CupertinoIcons.viewfinder_circle,
                                endIcon: CupertinoIcons.viewfinder_circle_fill,
                                value: _bloc.aspectRatioIndex == 0,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ];
              },
              body: GridView.builder(
                padding: EdgeInsets.only(
                  right: 2,
                  left: 2,
                  bottom: 30,
                ),
                itemCount: _bloc.media.length,
                itemBuilder: (context, index) {
                  return getImageWidget(_bloc.media[index]);
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1,
                  crossAxisCount: 3,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget getImageWidget(AssetEntity entity) {
    var selected = _bloc.selectedEntities.contains(entity);
    return FutureBuilder<Uint8List>(
      future: _bloc.getThumbnail(entity),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return simpleShimmer;
        }
        return Stack(
          children: [
            Positioned.fill(
              child: AnimatedPadding(
                padding: EdgeInsets.all(selected ? 10 : 0),
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Builder(builder: (context) {
                  var image = Image.memory(
                    snapshot.data,
                    fit: BoxFit.cover,
                  );
                  if (entity.type == AssetType.image) {
                    return image;
                  }
                  return Stack(
                    children: [
                      Positioned.fill(child: image),
                      Positioned.directional(
                        textDirection: Directionality.of(context),
                        start: 5,
                        bottom: 5,
                        child: getVideoDurationThumbnail(entity.duration),
                      ),
                    ],
                  );
                }),
              ),
            ),
            Positioned.directional(
              top: 5,
              end: 5,
              textDirection: Directionality.of(context),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  _bloc.add(SelectMediaPostAdEvent(entity));
                },
                child: Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.blue : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected ? AppColors.deepGray : AppColors.white,
                    ),
                  ),
                  child: selected
                      ? Center(
                          child: Text(
                            "${_bloc.selectedEntities.indexOf(entity) + 1}",
                            style: AppTextStyle.smallWhite,
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Widget getThumbnail(AssetEntity entity){
  //   if(entity)
  // }

  Widget getSlider() {
    return BlocBuilder<PostAdBloc, PostAdState>(
      buildWhen: (_, current) => current is PostAdChangeDisplayModeState,
      builder: (context, state) {
        var media = _bloc.getSelectedMedias();
        return Hero(
          tag: "thumbnail",
          child: Swiper(
            itemCount: media.length,
            pagination: swiperPagination,
            itemBuilder: (context, index) {
              var entity = media[index];
              return FutureBuilder<Uint8List>(
                future: _bloc.getThumbnail(entity),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CupertinoActivityIndicator());
                  }
                  return Center(
                    child: AspectRatio(
                      aspectRatio: _bloc.aspectRatio.value,
                      child: Image.memory(
                        snapshot.data,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget getVideoDurationThumbnail(int duration) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
        ),
        child: Row(
          children: [
            Icon(
              CupertinoIcons.play_arrow_solid,
              color: AppColors.white,
              size: AppFontSize.xSmall,
            ),
            SizedBox(width: 2),
            Text(
              "${Utils.formatDurationFromInt(duration)}",
              style: AppTextStyle.thumbnail,
            ),
          ],
        ),
      ),
    );
  }

  Widget getNextButton() {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: BlocBuilder<PostAdBloc, PostAdState>(
          buildWhen: (_, current) =>
              current is PostAdAcceptState ||
              current is PostAdSelectMediaState,
          builder: (context, state) {
            return Badge(
              position: BadgePosition.topEnd(top: -12),
              badgeColor: AppColors.blue,
              badgeContent: Text(
                "${_bloc.selectedEntities.length}",
                style: AppTextStyle.smallWhite,
              ),
              child: Text(
                AppLocalization.of(context).translate("next"),
                style: AppTextStyle.largeBlue,
              ),
            );
          },
        ),
      ),
      onTap: () {
        if (_bloc.selectedEntities.length < 1) {
          Fluttertoast.showToast(
            msg: AppLocalization.of(context)
                .translate("choose_one_media_at_least"),
          );
          return;
        }
        Navigator.of(context).push(CupertinoPageRoute(
          builder: (context) => BlocProvider.value(
            value: _bloc,
            child: PostAdDetailsLayout(),
          ),
        ));
      },
    );
  }
}
