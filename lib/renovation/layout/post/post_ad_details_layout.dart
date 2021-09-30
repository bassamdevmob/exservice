import 'package:exservice/renovation/bloc/view/post_ad_bloc/post_ad_bloc.dart';
import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/styles/app_colors.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:exservice/renovation/utils/utils.dart';
import 'package:exservice/renovation/widget/application/global_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
          Row(
            children: [
              Expanded(
                child: getPicker(
                  onTap: pick,
                ),
              ),
              Expanded(
                child: getPicker(
                  onTap: pick,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pick() {
    var mediaQuery = MediaQuery.of(context);
    showCupertinoModalBottomSheet(
      context: context,
      topRadius: Radius.circular(20),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: Utils.verticalSpace(mediaQuery)),
              LineBottomSheetWidget(),
              SizedBox(height: Utils.verticalSpace(mediaQuery)),
              Material(
                child: Wrap(
                  children: [
                    InputChip(label: Text("1 Room")),
                    InputChip(label: Text("2 Room")),
                    InputChip(label: Text("3 Room")),
                    InputChip(label: Text("4 Room")),
                    InputChip(label: Text("5 Room")),
                    InputChip(label: Text("6 Room")),
                    InputChip(label: Text("7 Room")),
                    InputChip(label: Text("8 Room")),
                    InputChip(label: Text("9 Room")),
                    InputChip(label: Text("More")),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget getPicker({VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalization.of(context).trans("rooms"),
                textAlign: TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Text(
                "5 rooms",
                style: AppTextStyle.mediumGray,
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
