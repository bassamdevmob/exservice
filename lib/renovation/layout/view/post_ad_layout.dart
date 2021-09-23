import 'dart:io';

import 'package:exservice/renovation/bloc/view/post_ad_bloc/post_ad_bloc.dart';
import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/styles/app_colors.dart';
import 'package:exservice/renovation/styles/app_font_size.dart';
import 'package:exservice/renovation/widget/application/animated_cross_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return BlocBuilder<PostAdBloc, PostAdState>(
      buildWhen: (_, current) =>
          current is PostAdAwaitState ||
          current is PostAdReceiveState ||
          current is PostAdSelectMediaState ||
          current is PostAdErrorState,
      builder: (context, state) {
        if (state is PostAdAwaitState) {
          return Center(child: CupertinoActivityIndicator());
        }
        return NestedScrollView(
          controller: _bloc.nestedScrollController,
          headerSliverBuilder: (context, _) {
            return [
              SliverStack(
                children: [
                  SliverToBoxAdapter(
                    child: AspectRatio(
                      aspectRatio: ratios.first.value,
                      child: FutureBuilder<File>(
                        future: _bloc.selectedEntities.first.file,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CupertinoActivityIndicator());
                          }
                          return BlocBuilder<PostAdBloc, PostAdState>(
                            buildWhen: (_, current) =>
                                current is PostAdChangeDisplayModeState,
                            builder: (context, state) {
                              return Center(
                                child: AspectRatio(
                                  aspectRatio: _bloc.aspectRatio.value,
                                  child: Image.file(
                                    snapshot.data,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
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
                        print(_bloc.index);
                        return GestureDetector(
                          onTap: () {
                            _bloc.add(ChangeDisplayModePostAdEvent());
                          },
                          child: AnimatedCrossIcon(
                            startIcon: CupertinoIcons.viewfinder_circle,
                            endIcon: CupertinoIcons.viewfinder_circle_fill,
                            value: _bloc.index == 0,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SliverPinnedHeader(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.black.withOpacity(0.2),
                  ),
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: AppColors.black.withOpacity(0.8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                AppLocalization.of(context).trans("next"),
                              ),
                              Icon(
                                CupertinoIcons.chevron_right,
                                color: AppColors.white,
                                size: AppFontSize.MEDIUM,
                              ),
                            ],
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
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
              return FutureBuilder<File>(
                future: _bloc.media[index].file,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }
                  var selected = _bloc.selectedEntities.contains(
                    _bloc.media[index],
                  );
                  return GestureDetector(
                    onTap: () {
                      _bloc.add(SelectMediaPostAdEvent(_bloc.media[index]));
                    },
                    child: Padding(
                      padding: EdgeInsets.all(selected ? 4 : 0),
                      child: Image.file(
                        snapshot.data,
                        fit: BoxFit.cover,
                        colorBlendMode: BlendMode.darken,
                        color:
                            selected ? AppColors.black.withOpacity(0.5) : null,
                      ),
                    ),
                  );
                },
              );
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
    );
  }
}
