import 'package:exservice/bloc/upload_manger_bloc/upload_manager_bloc.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/utils/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UploadManagerLayout extends StatefulWidget {
  const UploadManagerLayout({Key key}) : super(key: key);

  @override
  State<UploadManagerLayout> createState() => _UploadManagerLayoutState();
}

class _UploadManagerLayoutState extends State<UploadManagerLayout> {
  UploadManagerBloc _bloc;

  @override
  void initState() {
    _bloc = context.read<UploadManagerBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.separated(
        itemCount: _bloc.tasks.length,
        itemBuilder: (context, index) {
          var task = _bloc.tasks[index];
          return Container(
            decoration: BoxDecoration(
              color: AppColors.gray.withOpacity(0.1),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: Sizer.vs3,
                horizontal: Sizer.hs3,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          task.title,
                          maxLines: 1,
                          style: Theme.of(context).primaryTextTheme.bodyMedium,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        "uploading",
                        style: Theme.of(context)
                            .primaryTextTheme
                            .titleSmall
                            .copyWith(decoration: TextDecoration.underline),
                      ),
                    ],
                  ),
                  SizedBox(height: Sizer.vs3),
                  for (var entity in task.entities)
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                        top: 5,
                        bottom: 5,
                        start: 8,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: Sizer.iconSizeLarge,
                            child: AspectRatio(
                              aspectRatio: task.mode.value,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.memory(
                                  task.thumbnails[entity],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: Sizer.hs3),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: LinearProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(AppColors.blueAccent),
                                    value: 0.7,
                                  ),
                                ),
                                Text(
                                  "completed",
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .titleSmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => Divider(),
      ),
    );
  }
}
