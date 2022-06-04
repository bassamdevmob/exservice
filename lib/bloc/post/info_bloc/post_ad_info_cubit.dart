import 'package:bloc/bloc.dart';
import 'package:exservice/bloc/post/media_picker_bloc/post_ad_media_picker_bloc.dart';
import 'package:exservice/utils/localized.dart';
import 'package:flutter/cupertino.dart';

part 'post_ad_info_state.dart';

class PostAdInfoCubit extends Cubit<PostAdInfoState> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final PostAdMediaPickerBloc mediaBloc;

  @override
  Future<void> close() {
    titleController.dispose();
    descriptionController.dispose();
    return super.close();
  }

  Localized titleErrorMessage;
  Localized descriptionErrorMessage;

  bool get valid =>
      titleErrorMessage == null && descriptionErrorMessage == null;

  void _validate() {
    String title = titleController.text.trim();
    String description = descriptionController.text.trim();

    titleErrorMessage = title.isEmpty ? Localized("filed_required") : null;

    descriptionErrorMessage =
        description.isEmpty ? Localized("filed_required") : null;
  }

  PostAdInfoCubit(this.mediaBloc) : super(PostAdInfoInitial());

  void next() {
    _validate();
    emit(PostAdInfoValidationState());
    if (valid) {
      String title = titleController.text.trim();
      String description = descriptionController.text.trim();
      emit(PostAdInfoAcceptState());
    }
  }
}
