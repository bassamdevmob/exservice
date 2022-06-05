import 'package:exservice/bloc/post/info_bloc/post_ad_info_cubit.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:exservice/utils/sizer.dart';
import 'package:exservice/widget/application/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostAdInfoLayout extends StatefulWidget {
  @override
  _PostAdInfoLayoutState createState() => _PostAdInfoLayoutState();
}

class _PostAdInfoLayoutState extends State<PostAdInfoLayout> {
  PostAdInfoCubit _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<PostAdInfoCubit>(context);
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
      body: ListView(
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
                        aspectRatio: _bloc.mediaBloc.mode.value,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Hero(
                            tag: "thumbnail",
                            child: Image.memory(
                              _bloc.mediaBloc.thumbnail,
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
            leading: Icon(Icons.bed),
            title: Text(
              AppLocalization.of(context).translate("rooms"),
            ),
            trailing: getTrailing(context),
            onTap: () {

            },
          ),
          ListTile(
            leading: Icon(Icons.bathroom_outlined),
            title: Text(
              AppLocalization.of(context).translate("bathrooms"),
            ),
            trailing: getTrailing(context),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.chair_outlined),
            title: Text(
              AppLocalization.of(context).translate("furniture"),
            ),
            trailing: getTrailing(context),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.house_outlined),
            title: Text(
              AppLocalization.of(context).translate("type"),
            ),
            trailing: getTrailing(context),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.security_outlined),
            title: Text(
              AppLocalization.of(context).translate("security"),
            ),
            trailing: getTrailing(context),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.sports_sharp),
            title: Text(
              AppLocalization.of(context).translate("gym"),
            ),
            trailing: getTrailing(context),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.terrain_outlined),
            title: Text(
              AppLocalization.of(context).translate("terrace"),
            ),
            trailing: getTrailing(context),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.garage_outlined),
            title: Text(
              AppLocalization.of(context).translate("garage"),
            ),
            trailing: getTrailing(context),
            onTap: () {},
          ),
        ],
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
      onTap: () {},
    );
  }
}
