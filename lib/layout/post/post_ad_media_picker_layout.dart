import 'dart:typed_data';

import 'package:badges/badges.dart';
import 'package:exservice/bloc/post/info_bloc/post_ad_info_cubit.dart';
import 'package:exservice/bloc/post/media_picker_bloc/post_ad_media_picker_bloc.dart';
import 'package:exservice/layout/post/post_ad_info_layout.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:exservice/utils/sizer.dart';
import 'package:exservice/widget/application/animated_cross_icon.dart';
import 'package:exservice/widget/application/global_widgets.dart';
import 'package:exservice/widget/application/reload_indicator.dart';
import 'package:exservice/widget/bottom_sheets/error_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sliver_tools/sliver_tools.dart';

class PostAdMediaPickerLayout extends StatefulWidget {
  @override
  _PostAdMediaPickerLayoutState createState() =>
      _PostAdMediaPickerLayoutState();
}

class _PostAdMediaPickerLayoutState extends State<PostAdMediaPickerLayout> {
  PostAdMediaPickerBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<PostAdMediaPickerBloc>(context);
    _bloc.add(PostAdMediaPickerFetchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostAdMediaPickerBloc, PostAdMediaPickerState>(
      listenWhen: (_, current) =>
          current is PostAdMediaPickerMaxLimitsErrorState,
      listener: (context, state) {
        if (state is PostAdMediaPickerMaxLimitsErrorState) {
          showErrorBottomSheet(
            context,
            title: AppLocalization.of(context).translate("error"),
            message: AppLocalization.of(context).translate("max_media"),
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
        body: BlocBuilder<PostAdMediaPickerBloc, PostAdMediaPickerState>(
          buildWhen: (_, current) =>
              current is PostAdMediaPickerAwaitState ||
              current is PostAdMediaPickerAcceptState ||
              current is PostAdMediaPickerDeniedState ||
              current is PostAdMediaPickerSelectMediaState,
          builder: (context, state) {
            if (state is PostAdMediaPickerAwaitState) {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            }
            if (state is PostAdMediaPickerDeniedState) {
              return Center(
                child: ReloadIndicator(
                  error: AppLocalization.of(context).translate("access_denied"),
                  onTap: () {
                    _bloc.add(PostAdMediaPickerFetchEvent());
                  },
                ),
              );
            }
            return NestedScrollView(
              headerSliverBuilder: (context, _) {
                return [
                  BlocBuilder<PostAdMediaPickerBloc, PostAdMediaPickerState>(
                    buildWhen: (_, current) =>
                        current is PostAdMediaPickerDisplayModeState,
                    builder: (context, state) {
                      return SliverStack(
                        children: [
                          SliverToBoxAdapter(
                            child: AspectRatio(
                              aspectRatio: AspectRatioMode.square.value,
                              child: Hero(
                                tag: "thumbnail",
                                child: Center(
                                  child: AspectRatio(
                                    aspectRatio: _bloc.mode.value,
                                    child: FutureBuilder<Uint8List>(
                                      future: _bloc.focusedThumbnail,
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Center(
                                            child: CupertinoActivityIndicator(),
                                          );
                                        }
                                        return Image.memory(
                                          snapshot.data,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SliverPositioned.directional(
                            bottom: 20,
                            start: 20,
                            textDirection: Directionality.of(context),
                            child: GestureDetector(
                              onTap: () {
                                _bloc.add(PostAdMediaPickerDisplayModeEvent());
                              },
                              child: AnimatedCrossIcon(
                                startIcon: CupertinoIcons.viewfinder_circle,
                                endIcon: CupertinoIcons.viewfinder_circle_fill,
                                value: _bloc.mode == AspectRatioMode.tight,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ];
              },
              body: GridView.builder(
                padding: EdgeInsets.only(
                  right: 2,
                  left: 2,
                  bottom: 30,
                ),
                itemCount: _bloc.entities.length,
                itemBuilder: (context, index) {
                  return getImageWidget(_bloc.entities[index]);
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1,
                  crossAxisCount: 4,
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
        if (!snapshot.hasData) return simpleShimmer;
        return GestureDetector(
          onTap: () {
            _bloc.add(PostAdMediaPickerFocusEvent(entity));
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.memory(
                snapshot.data,
                fit: BoxFit.cover,
                color: _bloc.focusedEntity == entity ? AppColors.gray : null,
                colorBlendMode: BlendMode.lighten,
              ),
              Positioned.directional(
                top: 4,
                end: 4,
                textDirection: Directionality.of(context),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    _bloc.add(PostAdMediaPickerSelectEvent(entity));
                  },
                  child: Container(
                    margin: EdgeInsets.all(5),
                    height: Sizer.iconSizeLarge,
                    width: Sizer.iconSizeLarge,
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
          ),
        );
      },
    );
  }

  Widget getNextButton() {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: BlocBuilder<PostAdMediaPickerBloc, PostAdMediaPickerState>(
          buildWhen: (_, current) =>
              current is PostAdMediaPickerAcceptState ||
              current is PostAdMediaPickerSelectMediaState,
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
            msg: AppLocalization.of(context).translate("min_media"),
          );
          return;
        }
        Navigator.of(context).push(CupertinoPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => PostAdInfoCubit()),
              BlocProvider.value(value: _bloc),
            ],
            child: PostAdInfoLayout(),
          ),
        ));
      },
    );
  }
}
