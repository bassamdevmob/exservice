import 'package:exservice/bloc/upload_manger_bloc/upload_manager_bloc.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/utils/sizer.dart';
import 'package:exservice/utils/utils.dart';
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

  Color getColor(TaskStatus status) {
    if (status == TaskStatus.completed) return AppColors.green;
    if (status == TaskStatus.failed) return AppColors.red;
    return AppColors.gray;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<UploadManagerBloc, UploadManagerState>(
        buildWhen: (previous, current) => current is UploadManagerUpdateState,
        builder: (context, state) {
          return ListView.separated(
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
                              task.model.title,
                              maxLines: 1,
                              style:
                                  Theme.of(context).primaryTextTheme.bodyMedium,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            task.status.name,
                            style: Theme.of(context)
                                .primaryTextTheme
                                .titleSmall
                                .copyWith(
                                  decoration: TextDecoration.underline,
                                  color: getColor(task.status),
                                ),
                          ),
                        ],
                      ),
                      if (task.status == TaskStatus.failed)
                        Text(
                          Utils.resolveErrorMessage(task.error),
                          style: Theme.of(context).primaryTextTheme.labelSmall,
                        ),
                      SizedBox(height: Sizer.vs3),
                      for (var entity in task.model.entities)
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
                                  aspectRatio: task.model.mode.value,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Image.memory(
                                      task.model.thumbnails[entity],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: Sizer.hs3),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: LinearProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation(
                                            AppColors.blueAccent),
                                        value:
                                            task.imagesUploadProgress[entity],
                                      ),
                                    ),
                                    Text(
                                      task.imagesUploadProgress[entity] == 1.0
                                          ? TaskStatus.completed.name
                                          : TaskStatus.uploading.name,
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
          );
        },
      ),
    );
  }
}
