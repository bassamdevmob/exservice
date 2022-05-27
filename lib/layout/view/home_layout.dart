import 'package:exservice/utils/constant.dart';
import 'package:exservice/bloc/view/home_bloc/home_bloc.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:exservice/widget/application/animated_avatar.dart';
import 'package:exservice/widget/application/global_widgets.dart';
import 'package:exservice/widget/application/reload_widget.dart';
import 'package:exservice/widget/cards/summary_ad_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:octo_image/octo_image.dart';
import 'package:shimmer/shimmer.dart';

class HomeLayout extends StatefulWidget {
  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  HomeBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<HomeBloc>(context);
    _bloc.add(HomeFetchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: BlocBuilder<HomeBloc, HomeState>(
        buildWhen: (_, current) =>
            current is HomeAwaitCategoriesState ||
            current is HomeReceiveCategoriesState ||
            current is HomeErrorCategoriesState,
        builder: (context, state) {
          if (state is HomeErrorCategoriesState) {
            return Center(
              child: ReloadWidget.error(
                content: Text(state.message, textAlign: TextAlign.center),
                onPressed: () {
                  _bloc.add(HomeFetchEvent());
                },
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: <Widget>[
                Expanded(child: getSlider()),
                SizedBox(height: 5),
                getCategories(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget getSlider() {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (_, current) =>
          current is HomeAwaitState ||
          current is HomeAccessibleState ||
          current is HomeErrorAdsState,
      builder: (context, state) {
        if (state is HomeErrorAdsState) {
          return Center(
            child: ReloadWidget.error(
              content: Text(state.message, textAlign: TextAlign.center),
              onPressed: () {
                _bloc.add(HomeFetchAdsEvent());
              },
            ),
          );
        } else if (state is HomeAwaitState) {
          return Center(child: CupertinoActivityIndicator());
        } else if (_bloc.models == null || _bloc.models.isEmpty) {
          return Center(
            child: ReloadWidget.empty(
              content: Text(
                AppLocalization.of(context).translate("empty"),
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                _bloc.add(HomeFetchAdsEvent());
              },
            ),
          );
        }
        return Swiper(
          viewportFraction: 0.73,
          scale: 0.74,
          duration: 100,
          loop: false,
          itemCount: _bloc.models.length,
          itemBuilder: (context, index) {
            return SummaryAdCard(
              title: _bloc.models[index].title,
              avatar: _bloc.models[index].owner.profilePicture,
              images: _bloc.models[index].media.gallery.map((e) => e.link).toList(),
            );
          },
        );
      },
    );
  }

  Widget getCategories() {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (_, current) =>
          current is HomeSelectCategoryState ||
          current is HomeAwaitCategoriesState ||
          current is HomeReceiveCategoriesState,
      builder: (context, state) {
        if (state is HomeAwaitCategoriesState) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(10, (index) {
                return Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.grayAccent,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.5),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300],
                            highlightColor: Colors.grey[100],
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        '${AppLocalization.of(context).translate('loading')} ..',
                        style: AppTextStyle.mediumGray,
                      )
                    ],
                  ),
                );
              }),
            ),
          );
        }
        if (_bloc.categories == null || _bloc.categories.isEmpty) {
          return SizedBox();
        }
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List<Widget>.generate(_bloc.categories.length, (index) {
              return AnimatedAvatar(
                checked: _bloc.categoryId == _bloc.categories[index].id,
                text: _bloc.categories[index].title,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                size: 70,
                image: OctoImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(_bloc.categories[index].image),
                  progressIndicatorBuilder: (ctx, _) => simpleShimmer,
                  errorBuilder: (ctx, e, _) =>
                      Image.asset(PLACEHOLDER, fit: BoxFit.cover),
                ),
                onTap: () {
                  _bloc.add(HomeSelectCategoryEvent(
                    _bloc.categories[index].id,
                  ));
                },
              );
            }),
          ),
        );
      },
    );
  }
}
