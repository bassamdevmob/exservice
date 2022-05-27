import 'package:exservice/utils/constant.dart';
import 'package:exservice/bloc/chat/chat_bloc.dart';
import 'package:exservice/bloc/publisher_bloc/publisher_cubit.dart';
import 'package:exservice/bloc/profile_bloc/profile_bloc.dart';
import 'package:exservice/layout/chat/chat_layout.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:exservice/utils/enums.dart';
import 'package:exservice/utils/utils.dart';
import 'package:exservice/widget/application/dotted_container.dart';
import 'package:exservice/widget/application/global_widgets.dart';
import 'package:exservice/widget/application/reload_widget.dart';
import 'package:exservice/widget/button/app_button.dart';
import 'package:exservice/widget/application/app_video.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:octo_image/octo_image.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:string_validator/string_validator.dart';

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

  @override
  Widget build(BuildContext context) {
    var dimension = 80.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        iconTheme: IconThemeData(color: AppColors.blue),
        centerTitle: true,
        title: Text(
          AppLocalization.of(context).translate('app_name'),
          style: AppTextStyle.largeBlack,
        ),
      ),
      body: BlocBuilder<PublisherCubit, PublisherState>(
        buildWhen: (_, current) =>
            current is PublisherAwaitState ||
            current is PublisherReceivedState ||
            current is PublisherErrorState,
        builder: (context, state) {
          if (state is PublisherErrorState) {
            return Center(
              child: ReloadWidget.error(
                content: Text(state.message, textAlign: TextAlign.center),
                onPressed: () {
                  _bloc.fetch();
                },
              ),
            );
          }
          if (state is PublisherAwaitState) {
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
            child: NestedScrollView(
              controller: _bloc.scrollController,
              dragStartBehavior: DragStartBehavior.start,
              headerSliverBuilder: (context, _) {
                return [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 5),
                            child: OutlineContainer(
                              radius: dimension / 2,
                              dimension: dimension,
                              strokeWidth: 1,
                              gradient: LinearGradient(
                                colors: [AppColors.blue, AppColors.deepPurple],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              child: ClipOval(
                                child: OctoImage(
                                  fit: BoxFit.cover,
                                  image:
                                  NetworkImage(_bloc.publisher.profilePicture),
                                  progressIndicatorBuilder: (context, _) =>
                                  simpleShimmer,
                                  errorBuilder: (context, e, _) => Image.asset(
                                    PLACEHOLDER,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Text(
                                  _bloc.publisher.username,
                                  style: AppTextStyle.largeBlack,
                                  maxLines: 1,
                                ),
                                if (_bloc.publisher.country != null)
                                  Text(
                                    _bloc.publisher.country,
                                    style: AppTextStyle.largeBlack,
                                    maxLines: 1,
                                  )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      if (_bloc.publisher.type == UserType.BUSINESS.name)
                        ...getBusinessInfo(),
                      if (context.read<ProfileBloc>().model.id !=
                          _bloc.publisher.id) ...[
                        getContactToolbar(),
                        Divider(),
                      ],
                    ]),
                  ),
                  SliverPinnedHeader(child: getTabFormat()),
                ];
              },
              body: BlocBuilder<PublisherCubit, PublisherState>(
                buildWhen: (_, current) =>
                    current is PublisherChangeFormatState,
                builder: (context, state) {
                  return getBody();
                },
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> getBusinessInfo() {
    return [
      if (_bloc.publisher.profileVideo != null)
        Padding(
          padding: const EdgeInsets.all(10),
          child: AppVideo.network(
            "${_bloc.publisher.profileVideo}",
            fit: false,
          ),
        ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              _bloc.publisher.type,
              style: AppTextStyle.largeBlack,
            ),
            if (_bloc.publisher.business.website != null &&
                isURL(_bloc.publisher.business.website))
              InkWell(
                onTap: () {
                  Utils.launchWeb(context, _bloc.publisher.business.website)
                      .catchError((e) {
                    Fluttertoast.showToast(msg: e);
                  });
                },
                child: Text(
                  _bloc.publisher.business.website,
                  style: AppTextStyle.mediumBlue,
                ),
              ),
            if (_bloc.publisher.business.bio != null &&
                _bloc.publisher.business.bio.isNotEmpty)
              Text(
                _bloc.publisher.business.bio,
                style: AppTextStyle.mediumBlack,
              ),
          ],
        ),
      ),
      Divider(),
    ];
  }

  Widget getContactToolbar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        if (_bloc.publisher.phoneNumber != null)
          AppButton(
            child: Text(
              AppLocalization.of(context).translate("call"),
              style: AppTextStyle.largeBlack,
            ),
            onTap: () {
              Utils.launchCall(context, _bloc.publisher.phoneNumber)
                  .catchError((e) => Fluttertoast.showToast(msg: e));
            },
          ),
        AppButton(
          child: Text(
            AppLocalization.of(context).translate("chat"),
            style: AppTextStyle.largeBlack,
          ),
          onTap: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => ChatBloc(
                    BlocProvider.of<ProfileBloc>(context).model,
                    _bloc.publisher,
                  ),
                  child: ChatLayout(),
                ),
              ),
            );
          },
        ),
        if (_bloc.publisher.email != null)
          AppButton(
            child: Text(
              AppLocalization.of(context).translate("email2"),
              style: AppTextStyle.largeBlack,
            ),
            onTap: () {
              Utils.launchMail(context, _bloc.publisher.email)
                  .catchError((e) => Fluttertoast.showToast(msg: e));
            },
          ),
      ],
    );
  }

  Widget getTabFormat() {
    return BlocBuilder<PublisherCubit, PublisherState>(
      buildWhen: (_, current) => current is PublisherChangeFormatState,
      builder: (context, state) {
        return ColoredBox(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    _bloc.changeFormat(DisplayFormat.list);
                  },
                  child: Icon(
                    Icons.view_day,
                    color: _bloc.format == DisplayFormat.list
                        ? AppColors.blue
                        : AppColors.deepGray,
                  ),
                ),
                InkWell(
                  onTap: () {
                    _bloc.changeFormat(DisplayFormat.grid);
                  },
                  child: Icon(
                    Icons.dashboard,
                    color: _bloc.format == DisplayFormat.grid
                        ? AppColors.blue
                        : AppColors.deepGray,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget getBody() {
    var profile = _bloc.publisher;
    return SizedBox();
    // switch (_bloc.format) {
    //   case DisplayFormat.grid:
    //     return GridView.count(
    //       shrinkWrap: true,
    //       crossAxisSpacing: 5,
    //       mainAxisSpacing: 10,
    //       crossAxisCount: 2,
    //       padding: EdgeInsets.only(right: 5, left: 5, bottom: 10),
    //       childAspectRatio: (4 / 7),
    //       scrollDirection: Axis.vertical,
    //       children: List.generate(profile.ads.length, (index) {
    //         return GridAdCard(profile.ads[index]);
    //       }),
    //     );
    //   default:
    //     return ListView.builder(
    //       itemCount: profile.ads.length,
    //       itemBuilder: (context, index) {
    //         return ListAdCard(profile.ads[index]);
    //       },
    //     );
    // }
  }
}
