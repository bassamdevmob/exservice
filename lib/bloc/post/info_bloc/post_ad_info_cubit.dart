import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:exservice/models/response/config_response.dart';
import 'package:exservice/resources/repository/config_repository.dart';
import 'package:exservice/utils/localized.dart';
import 'package:exservice/widget/bottom_sheets/numeric_input_bottom_sheet.dart';
import 'package:exservice/widget/bottom_sheets/option_picker_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'post_ad_info_state.dart';

class PostAdInfoCubit extends Cubit<PostAdInfoState> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  Config data;

  LatLng location;
  OptionResult type;
  OptionResult trade;
  NumericResult price;
  NumericResult size;

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

  void updateType(OptionResult result) {
    type = result;
    emit(PostAdInfoUpdateState());
  }

  void updateTrade(OptionResult result) {
    trade = result;
    emit(PostAdInfoUpdateState());
  }

  void updatePosition(LatLng result) {
    location = result;
    emit(PostAdInfoUpdateState());
  }

  void updatePrice(NumericResult result) {
    price = result;
    emit(PostAdInfoUpdateState());
  }

  void updateSize(NumericResult result) {
    size = result;
    emit(PostAdInfoUpdateState());
  }
}
