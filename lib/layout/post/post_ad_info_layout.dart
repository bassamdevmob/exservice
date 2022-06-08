import 'package:exservice/bloc/post/info_bloc/post_ad_info_cubit.dart';
import 'package:exservice/bloc/post/media_picker_bloc/post_ad_media_picker_bloc.dart';
import 'package:exservice/layout/post/extra_notes_layout.dart';
import 'package:exservice/layout/post/map_picker_layout.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:exservice/utils/sizer.dart';
import 'package:exservice/widget/application/global_widgets.dart';
import 'package:exservice/widget/application/reload_indicator.dart';
import 'package:exservice/widget/bottom_sheets/numeric_input_bottom_sheet.dart';
import 'package:exservice/widget/bottom_sheets/option_picker_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class PostAdInfoLayout extends StatefulWidget {
  @override
  _PostAdInfoLayoutState createState() => _PostAdInfoLayoutState();
}

class _PostAdInfoLayoutState extends State<PostAdInfoLayout> {
  PostAdInfoCubit _bloc;
  NumberFormat format = NumberFormat();

  @override
  void initState() {
    _bloc = BlocProvider.of<PostAdInfoCubit>(context);
    _bloc.fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mediaBloc = BlocProvider.of<PostAdMediaPickerBloc>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          Center(
            child: getNextButton(),
          ),
        ],
      ),
      body: BlocBuilder<PostAdInfoCubit, PostAdInfoState>(
        buildWhen: (previous, current) =>
            current is PostAdInfoValidationState ||
            current is PostAdInfoAwaitState ||
            current is PostAdInfoAcceptState ||
            current is PostAdInfoErrorState ||
            current is PostAdInfoUpdateState,
        builder: (context, state) {
          if (state is PostAdInfoAwaitState) {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }
          if (state is PostAdInfoErrorState) {
            return Center(
              child: ReloadIndicator(
                error: state.error,
                onTap: () {
                  _bloc.fetch();
                },
              ),
            );
          }
          return ListView(
            padding: EdgeInsets.only(bottom: Sizer.vs1),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: Sizer.vs3,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: Sizer.avatarSizeLarge,
                          child: AspectRatio(
                            aspectRatio: mediaBloc.mode.value,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Hero(
                                tag: "thumbnail",
                                child: Image.memory(
                                  mediaBloc.thumbnail,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: Sizer.hs3),
                        Expanded(
                          child: TextField(
                            maxLines: 1,
                            controller: _bloc.titleController,
                            decoration: InputDecoration(
                              hintText:
                                  "${AppLocalization.of(context).translate("write_title")}...",
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    TextField(
                      maxLines: 3,
                      controller: _bloc.descriptionController,
                      decoration: InputDecoration(
                        hintText:
                            "${AppLocalization.of(context).translate("write_caption")}...",
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Sizer.vs3),
              ListTile(
                leading: Icon(Icons.house_outlined),
                title: Text(
                  AppLocalization.of(context).translate("type"),
                ),
                subtitle:
                    _bloc.type == null ? null : Text(_bloc.type.option.text),
                trailing: getTrailing(context),
                onTap: () {
                  OptionPickerBottomSheet.show(
                    context,
                    title: AppLocalization.of(context).translate("type"),
                    selected: _bloc.type,
                    elements: _bloc.data.type,
                  ).then((result) {
                    if (result != null) {
                      _bloc.updateType(result);
                    }
                  });
                },
              ),
              ListTile(
                leading: Icon(Icons.assignment_outlined),
                title: Text(
                  AppLocalization.of(context).translate("trade"),
                ),
                subtitle:
                    _bloc.trade == null ? null : Text(_bloc.trade.option.text),
                trailing: getTrailing(context),
                onTap: () {
                  OptionPickerBottomSheet.show(
                    context,
                    title: AppLocalization.of(context).translate("trade"),
                    selected: _bloc.trade,
                    elements: _bloc.data.trade,
                  ).then((value) {
                    if (value != null) {
                      _bloc.updateTrade(value);
                    }
                  });
                },
              ),
              ListTile(
                leading: Icon(CupertinoIcons.location),
                title: Text(
                  AppLocalization.of(context).translate("location"),
                ),
                subtitle: _bloc.location == null
                    ? null
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "LAT: ${_bloc.location.latitude.toStringAsFixed(6)}"),
                          Text(
                              "LNG: ${_bloc.location.longitude.toStringAsFixed(6)}"),
                        ],
                      ),
                trailing: getTrailing(context),
                onTap: () {
                  Navigator.of(context).push<LatLng>(
                    CupertinoPageRoute(
                      builder: (context) {
                        return MapPickerLayout();
                      },
                    ),
                  ).then((value) {
                    if (value != null) {
                      _bloc.updatePosition(value);
                    }
                  });
                },
              ),
              ListTile(
                leading: Icon(CupertinoIcons.money_dollar),
                title: Text(
                  AppLocalization.of(context).translate("price"),
                ),
                subtitle: _bloc.price == null
                    ? null
                    : Text(
                        "${format.format(_bloc.price.value)} ${_bloc.price.unit.value}"),
                trailing: getTrailing(context),
                onTap: () {
                  NumericInputBottomSheet.show(
                    context,
                    title: AppLocalization.of(context).translate("price"),
                    initValue: _bloc.price,
                    unites: _bloc.data.priceUnit,
                  ).then((value) {
                    if (value != null) {
                      _bloc.updatePrice(value);
                    }
                  });
                },
              ),
              ListTile(
                leading: Icon(CupertinoIcons.resize),
                title: Text(
                  AppLocalization.of(context).translate("size"),
                ),
                subtitle: _bloc.size == null
                    ? null
                    : Text(
                        "${format.format(_bloc.size.value)} ${_bloc.size.unit.value}"),
                trailing: getTrailing(context),
                onTap: () {
                  NumericInputBottomSheet.show(
                    context,
                    title: AppLocalization.of(context).translate("size"),
                    initValue: _bloc.size,
                    unites: _bloc.data.sizeUnit,
                  ).then((value) {
                    if (value != null) {
                      _bloc.updateSize(value);
                    }
                  });
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget getNextButton() {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          AppLocalization.of(context).translate("next"),
          style: AppTextStyle.largeBlue,
        ),
      ),
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => ExtraNotesLayout(),
          ),
        );
      },
    );
  }
}
