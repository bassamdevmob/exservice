import 'package:exservice/bloc/post/info_bloc/compose_details_cubit.dart';
import 'package:exservice/layout/compose/extra_notes_layout.dart';
import 'package:exservice/layout/compose/map_picker_layout.dart';
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

class ComposeDetailsLayout extends StatefulWidget {
  @override
  _ComposeDetailsLayoutState createState() => _ComposeDetailsLayoutState();
}

class _ComposeDetailsLayoutState extends State<ComposeDetailsLayout> {
  ComposeDetailsCubit _bloc;
  NumberFormat format = NumberFormat();

  @override
  void initState() {
    _bloc = BlocProvider.of<ComposeDetailsCubit>(context);
    _bloc.fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Center(
            child: getNextButton(),
          ),
        ],
      ),
      body: BlocBuilder<ComposeDetailsCubit, ComposeDetailsState>(
        buildWhen: (previous, current) =>
            current is ComposeDetailsValidationState ||
            current is ComposeDetailsAwaitState ||
            current is ComposeDetailsAcceptState ||
            current is ComposeDetailsErrorState ||
            current is ComposeDetailsUpdateState,
        builder: (context, state) {
          if (state is ComposeDetailsAwaitState) {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }
          if (state is ComposeDetailsErrorState) {
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
                            aspectRatio: _bloc.repository.mode.value,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Hero(
                                tag: "thumbnail",
                                child: Image.memory(
                                  _bloc.repository.thumbnail,
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
                              errorText: _bloc.titleErrorMessage?.toString(),
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
                        errorText: _bloc.descriptionErrorMessage?.toString(),
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
                    _bloc.repository.type == null ? null : Text(_bloc.repository.type.option.text),
                trailing: getTrailing(context),
                onTap: () {
                  FocusScope.of(context).unfocus();
                  OptionPickerBottomSheet.show(
                    context,
                    title: AppLocalization.of(context).translate("type"),
                    selected: _bloc.repository.type,
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
                    _bloc.repository.trade == null ? null : Text(_bloc.repository.trade.option.text),
                trailing: getTrailing(context),
                onTap: () {
                  FocusScope.of(context).unfocus();
                  OptionPickerBottomSheet.show(
                    context,
                    title: AppLocalization.of(context).translate("trade"),
                    selected: _bloc.repository.trade,
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
                subtitle: _bloc.repository.location == null
                    ? null
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "LAT: ${_bloc.repository.location.latitude.toStringAsFixed(6)}"),
                          Text(
                              "LNG: ${_bloc.repository.location.longitude.toStringAsFixed(6)}"),
                        ],
                      ),
                trailing: getTrailing(context),
                onTap: () {
                  FocusScope.of(context).unfocus();
                  Navigator.of(context)
                      .push<LatLng>(
                    CupertinoPageRoute(
                      builder: (context) => MapPickerLayout(),
                    ),
                  )
                      .then((value) {
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
                subtitle: _bloc.repository.price == null
                    ? null
                    : Text(
                        "${format.format(_bloc.repository.price.value)} ${_bloc.repository.price.unit.value}"),
                trailing: getTrailing(context),
                onTap: () {
                  FocusScope.of(context).unfocus();
                  NumericInputBottomSheet.show(
                    context,
                    title: AppLocalization.of(context).translate("price"),
                    initValue: _bloc.repository.price,
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
                subtitle: _bloc.repository.size == null
                    ? null
                    : Text(
                        "${format.format(_bloc.repository.size.value)} ${_bloc.repository.size.unit.value}"),
                trailing: getTrailing(context),
                onTap: () {
                  FocusScope.of(context).unfocus();
                  NumericInputBottomSheet.show(
                    context,
                    title: AppLocalization.of(context).translate("size"),
                    initValue: _bloc.repository.size,
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
        _bloc.next();
        if (_bloc.valid) {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => BlocProvider.value(
                value: _bloc,
                child: ExtraNotesLayout(),
              ),
            ),
          );
        }
      },
    );
  }
}
