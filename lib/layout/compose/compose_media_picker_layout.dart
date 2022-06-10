import 'dart:typed_data';

import 'package:badges/badges.dart';
import 'package:exservice/bloc/post/composition_repository.dart';
import 'package:exservice/bloc/post/info_bloc/compose_details_cubit.dart';
import 'package:exservice/bloc/post/media_picker_bloc/compose_media_picker_bloc.dart';
import 'package:exservice/layout/compose/compose_details_layout.dart';
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

class ComposeMediaPickerLayout extends StatefulWidget {
  @override
  _ComposeMediaPickerLayoutState createState() =>
      _ComposeMediaPickerLayoutState();
}

class _ComposeMediaPickerLayoutState extends State<ComposeMediaPickerLayout> {
  ComposeMediaPickerBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<ComposeMediaPickerBloc>(context);
    _bloc.add(ComposeMediaPickerFetchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ComposeMediaPickerBloc, ComposeMediaPickerState>(
      listenWhen: (_, current) =>
          current is ComposeMediaPickerMaxLimitsErrorState,
      listener: (context, state) {
        if (state is ComposeMediaPickerMaxLimitsErrorState) {
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
            AppLocalization.of(context).translate('compose'),
          ),
          actions: [
            Center(
              child: getNextButton(),
            ),
          ],
        ),
        body: BlocBuilder<ComposeMediaPickerBloc, ComposeMediaPickerState>(
          buildWhen: (_, current) =>
              current is ComposeMediaPickerAwaitState ||
              current is ComposeMediaPickerAcceptState ||
              current is ComposeMediaPickerDeniedState ||
              current is ComposeMediaPickerSelectMediaState,
          builder: (context, state) {
            if (state is ComposeMediaPickerAwaitState) {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            }
            if (state is ComposeMediaPickerDeniedState) {
              return Center(
                child: ReloadIndicator(
                  error: AppLocalization.of(context).translate("access_denied"),
                  onTap: () {
                    _bloc.add(ComposeMediaPickerFetchEvent());
                  },
                ),
              );
            }
            return NestedScrollView(
              headerSliverBuilder: (context, _) {
                return [
                  BlocBuilder<ComposeMediaPickerBloc, ComposeMediaPickerState>(
                    buildWhen: (_, current) =>
                        current is ComposeMediaPickerDisplayModeState,
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
                                    aspectRatio: _bloc.repository.mode.value,
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
                                _bloc.add(ComposeMediaPickerDisplayModeEvent());
                              },
                              child: AnimatedCrossIcon(
                                startIcon: CupertinoIcons.viewfinder_circle,
                                endIcon: CupertinoIcons.viewfinder_circle_fill,
                                value: _bloc.repository.mode == AspectRatioMode.tight,
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
    var selected = _bloc.repository.entities.contains(entity);
    return FutureBuilder<Uint8List>(
      future: _bloc.getThumbnail(entity),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return simpleShimmer;
        return GestureDetector(
          onTap: () {
            _bloc.add(ComposeMediaPickerFocusEvent(entity));
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
                    _bloc.add(ComposeMediaPickerSelectEvent(entity));
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
                              "${_bloc.repository.entities.indexOf(entity) + 1}",
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
        child: BlocBuilder<ComposeMediaPickerBloc, ComposeMediaPickerState>(
          buildWhen: (_, current) =>
              current is ComposeMediaPickerAcceptState ||
              current is ComposeMediaPickerSelectMediaState,
          builder: (context, state) {
            return Badge(
              position: BadgePosition.topEnd(top: -12),
              badgeColor: AppColors.blue,
              badgeContent: Text(
                "${_bloc.repository.entities.length}",
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
        if (_bloc.repository.entities.length < 1) {
          Fluttertoast.showToast(
            msg: AppLocalization.of(context).translate("min_media"),
          );
          return;
        }

        Navigator.of(context).push(CupertinoPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => ComposeDetailsCubit(_bloc.repository),
            child: ComposeDetailsLayout(),
          ),
        ));
      },
    );
  }
}
