import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:exservice/bloc/post/media_picker_bloc/post_ad_media_picker_bloc.dart';
import 'package:exservice/models/response/config_response.dart';
import 'package:exservice/resources/repository/config_repository.dart';
import 'package:exservice/utils/localized.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

part 'post_ad_info_state.dart';

class PostAdInfoCubit extends Cubit<PostAdInfoState> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  Config data;

  Option type;
  Option trade;

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

  PostAdInfoCubit() : super(PostAdInfoAwaitState());

  void next() {
    _validate();
    emit(PostAdInfoValidationState());
    if (valid) {
      String title = titleController.text.trim();
      String description = descriptionController.text.trim();
    }
  }

  void fetch() async {
    try {
      emit(PostAdInfoAwaitState());
      var response = await GetIt.I.get<ConfigRepository>().config();
      data = response.data;
      emit(PostAdInfoAcceptState());
    } on DioError catch (ex) {
      emit(PostAdInfoErrorState(ex.error));
    }
  }

  void updateType(Option option) {
    type = option;
    emit(PostAdInfoUpdateState());
  }

  void updateTrade(Option option) {
    trade = option;
    emit(PostAdInfoUpdateState());
  }
}
