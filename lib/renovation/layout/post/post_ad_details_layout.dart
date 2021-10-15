import 'package:exservice/renovation/bloc/view/post_ad_bloc/post_ad_bloc.dart';
import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/styles/app_colors.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:exservice/renovation/widget/bottom_sheets/post_ad/option_picker_bottom_sheet.dart';
import 'package:exservice/renovation/widget/bottom_sheets/post_ad/polar_question_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
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

  String getPolarValue(bool value) {
    if (value == null) return AppLocalization.of(context).trans("unknown");
    if (value) return AppLocalization.of(context).trans("yes");
    return AppLocalization.of(context).trans("no");
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
              return Row(
                children: [
                  Expanded(
                    child: getPicker(
                      icon: Icons.bed,
                      title: AppLocalization.of(context).trans("rooms"),
                      value: "5 Rooms",
                      onTap: () {},
                      color: Colors.primaries[0],
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: getPicker(
                      icon: Icons.chair,
                      title: AppLocalization.of(context).trans("furniture"),
                      value: "5 Rooms",
                      onTap: () {
                        OptionPickerBottomSheet.show(
                          context,
                          elements: ["more"],
                          textBuilder: (e) => e,
                        );
                      },
                      color: Colors.primaries[1],
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: getPicker(
                      icon: Icons.garage,
                      title: AppLocalization.of(context).trans("garage"),
                      value: getPolarValue(_bloc.snapshot.garage),
                      color: Colors.primaries[2],
                      onTap: () {
                        PolarQuestionBottomSheet.show(context).then((value) {
                          if (value != null) {
                            _bloc.add(ChangeGaragePostAdEvent(value));
                          }
                        });
                      },
                    ),
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
            horizontal: 20,
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
