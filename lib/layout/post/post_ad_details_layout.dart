import 'package:exservice/bloc/view/post_ad_bloc/post_ad_bloc.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/models/entity/option_model.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:exservice/widget/bottom_sheets/option_picker_bottom_sheet.dart';
import 'package:exservice/widget/bottom_sheets/polar_question_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostAdDetailsLayout extends StatefulWidget {
  @override
  _PostAdDetailsLayoutState createState() => _PostAdDetailsLayoutState();
}

class _PostAdDetailsLayoutState extends State<PostAdDetailsLayout> {
  PostAdBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<PostAdBloc>(context);
    super.initState();
  }

  String _getPolarValue(bool value) {
    if (value == null) return AppLocalization.of(context).trans("unknown");
    if (value) return AppLocalization.of(context).trans("yes");
    return AppLocalization.of(context).trans("no");
  }

  String _getOptionValue(OptionModel value) {
    if (value == null) return AppLocalization.of(context).trans("unknown");
    return value.title;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        iconTheme: IconThemeData(color: AppColors.blue),
        centerTitle: true,
        title: Text(
          AppLocalization.of(context).trans('app_name'),
          style: AppTextStyle.largeBlack,
        ),
        actions: [
          Center(
            child: getNextButton(),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          vertical: 20,
          horizontal: size.width * 0.03,
        ),
        children: [
          Row(
            children: [
              SizedBox(
                height: size.height * 0.1,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Hero(
                      tag: "thumbnail",
                      child: Image.memory(
                        _bloc.thumbnail,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: size.width * 0.03),
              Expanded(
                child: TextField(
                  maxLines: 1,
                  controller: _bloc.titleController,
                  decoration: InputDecoration(
                    hintText:
                        "${AppLocalization.of(context).trans("enter_title")}...",
                    label: Text(AppLocalization.of(context).trans("title")),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.03),
          TextField(
            maxLines: 3,
            controller: _bloc.detailsController,
            decoration: InputDecoration(
              hintText:
                  "${AppLocalization.of(context).trans("enter_details")}...",
              label: Text(AppLocalization.of(context).trans("details")),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          SizedBox(height: size.height * 0.02),
          BlocBuilder<PostAdBloc, PostAdState>(
            buildWhen: (_, current) => current is PostAdChangeOptionState,
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: getPicker(
                          icon: Icons.bed,
                          title: AppLocalization.of(context).trans("rooms"),
                          value: _getOptionValue(_bloc.snapshot.room),
                          onTap: () {
                            OptionPickerBottomSheet.show<OptionModel>(
                              context,
                              elements: _bloc.dataCenter.rooms,
                              textBuilder: (e) => e.title,
                            ).then((value) {
                              if (value != null) {
                                _bloc.add(ChangeRoomPostAdEvent(value));
                              }
                            });
                          },
                          color: Colors.primaries[0],
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: getPicker(
                          icon: Icons.bathroom_rounded,
                          title: AppLocalization.of(context).trans("bathroom"),
                          value: _getOptionValue(_bloc.snapshot.bath),
                          onTap: () {
                            OptionPickerBottomSheet.show<OptionModel>(
                              context,
                              elements: _bloc.dataCenter.baths,
                              textBuilder: (e) => e.title,
                            ).then((value) {
                              if (value != null) {
                                _bloc.add(ChangeBathPostAdEvent(value));
                              }
                            });
                          },
                          color: Colors.primaries[1],
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: getPicker(
                          icon: Icons.chair,
                          title: AppLocalization.of(context).trans("furniture"),
                          value: _getOptionValue(_bloc.snapshot.furniture),
                          color: Colors.primaries[2],
                          onTap: () {
                            OptionPickerBottomSheet.show<OptionModel>(
                              context,
                              elements: _bloc.dataCenter.furniture,
                              textBuilder: (e) => e.title,
                            ).then((value) {
                              if (value != null) {
                                _bloc.add(ChangeFurniturePostAdEvent(value));
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: getPicker(
                          icon: Icons.house,
                          title: AppLocalization.of(context).trans("type"),
                          value: _getOptionValue(_bloc.snapshot.type),
                          onTap: () {
                            OptionPickerBottomSheet.show<OptionModel>(
                              context,
                              elements: _bloc.dataCenter.types,
                              textBuilder: (e) => e.title,
                            ).then((value) {
                              if (value != null) {
                                _bloc.add(ChangeTypePostAdEvent(value));
                              }
                            });
                          },
                          color: Colors.primaries[4],
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: getPicker(
                          icon: Icons.security,
                          title: AppLocalization.of(context).trans("security"),
                          value: _getOptionValue(_bloc.snapshot.security),
                          onTap: () {
                            OptionPickerBottomSheet.show<OptionModel>(
                              context,
                              elements: _bloc.dataCenter.security,
                              textBuilder: (e) => e.title,
                            ).then((value) {
                              if (value != null) {
                                _bloc.add(ChangeSecurityPostAdEvent(value));
                              }
                            });
                          },
                          color: Colors.primaries[5],
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: getPicker(
                          icon: Icons.api_sharp,
                          title: AppLocalization.of(context).trans("balcony"),
                          value: _getOptionValue(_bloc.snapshot.balcony),
                          color: Colors.primaries[6],
                          onTap: () {
                            OptionPickerBottomSheet.show<OptionModel>(
                              context,
                              elements: _bloc.dataCenter.balcony,
                              textBuilder: (e) => e.title,
                            ).then((value) {
                              if (value != null) {
                                _bloc.add(ChangeBalconyPostAdEvent(value));
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: getPicker(
                          icon: Icons.directions_run,
                          title: AppLocalization.of(context).trans("gym"),
                          value: _getPolarValue(_bloc.snapshot.gym),
                          onTap: () {
                            PolarQuestionBottomSheet.show(context)
                                .then((value) {
                              if (value != null) {
                                _bloc.add(ChangeGymPostAdEvent(value));
                              }
                            });
                          },
                          color: Colors.primaries[7],
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: getPicker(
                          icon: Icons.terrain_outlined,
                          title: AppLocalization.of(context).trans("terrace"),
                          value: _getPolarValue(_bloc.snapshot.terrace),
                          color: Colors.primaries[8],
                          onTap: () {
                            PolarQuestionBottomSheet.show(context)
                                .then((value) {
                              if (value != null) {
                                _bloc.add(ChangeTerracePostAdEvent(value));
                              }
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: getPicker(
                          icon: Icons.garage,
                          title: AppLocalization.of(context).trans("garage"),
                          value: _getPolarValue(_bloc.snapshot.garage),
                          color: Colors.primaries[9],
                          onTap: () {
                            PolarQuestionBottomSheet.show(context)
                                .then((value) {
                              if (value != null) {
                                _bloc.add(ChangeGaragePostAdEvent(value));
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget getPicker({
    IconData icon,
    String title,
    String value,
    Color color,
    VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.5),
        borderRadius: BorderRadius.circular(5),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: AppColors.white,
              ),
              Text(
                title,
                textAlign: TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.largeWhiteBold,
              ),
              Text(
                value,
                style: AppTextStyle.mediumWhite,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getNextButton() {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          AppLocalization.of(context).trans("next"),
          style: AppTextStyle.largeBlue,
        ),
      ),
      onTap: () {},
    );
  }
}
