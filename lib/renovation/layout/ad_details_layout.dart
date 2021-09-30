import 'package:exservice/helper/AppConstant.dart';
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
import 'package:exservice/widget/application/AppVideo.dart';
import 'package:exservice/widget/application/BookMark.dart';
import 'package:exservice/widget/application/MoreAdInfo.dart';
import 'package:exservice/widget/application/OwnerAdHeader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
              OwnerAdHeader(_bloc.details),
              if (_bloc.details.media.isNotEmpty)
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
                          progressIndicatorBuilder: (context, _) =>
                              simpleShimmer,
                          errorBuilder: (context, e, _) => Image.asset(
                            AppConstant.placeholder,
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
                  if (DataStore.instance.user.id == _bloc.details.ownerId) {
                    return content;
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(child: content),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: BookMark(_bloc.details.id, _bloc.details.saved),
                      ),
                    ],
                  );
                }),
              ),
              MoreAdInfo.fromAdAttribute(_bloc.details, _bloc.position),
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
}
