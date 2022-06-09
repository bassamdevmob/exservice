import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:exservice/models/response/config_response.dart';
import 'package:exservice/resources/repository/config_repository.dart';
import 'package:exservice/utils/localized.dart';
import 'package:exservice/widget/bottom_sheets/note_input_bottom_sheet.dart';
import 'package:exservice/widget/bottom_sheets/numeric_input_bottom_sheet.dart';
import 'package:exservice/widget/bottom_sheets/option_picker_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'compose_details_state.dart';

class ComposeDetailsCubit extends Cubit<ComposeDetailsState> {

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  Config data;

  LatLng location;
  OptionResult type;
  OptionResult trade;
  NumericResult price;
  NumericResult size;
  final List<String> notes = [];

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

    titleErrorMessage = title.isEmpty ? Localized("field_required") : null;

    descriptionErrorMessage =
        description.isEmpty ? Localized("field_required") : null;
  }

  ComposeDetailsCubit() : super(ComposeDetailsAwaitState());

  void next() {
    _validate();
    emit(ComposeDetailsValidationState());
  }

  void fetch() async {
    try {
      emit(ComposeDetailsAwaitState());
      var response = await GetIt.I.get<ConfigRepository>().config();
      data = response.data;
      emit(ComposeDetailsAcceptState());
    } on DioError catch (ex) {
      emit(ComposeDetailsErrorState(ex.error));
    }
  }

  void updateType(OptionResult result) {
    type = result;
    emit(ComposeDetailsUpdateState());
  }

  void updateTrade(OptionResult result) {
    trade = result;
    emit(ComposeDetailsUpdateState());
  }

  void updatePosition(LatLng result) {
    location = result;
    emit(ComposeDetailsUpdateState());
  }

  void updatePrice(NumericResult result) {
    price = result;
    emit(ComposeDetailsUpdateState());
  }

  void updateSize(NumericResult result) {
    size = result;
    emit(ComposeDetailsUpdateState());
  }

  void newNote() {
    notes.add("");
    emit(ComposeDetailsUpdateState());
  }

  void removeNote(int index) {
    notes.removeAt(index);
    emit(ComposeDetailsUpdateState());
  }

  void updateNote(int index, NoteResult result) {
    notes[index] = result.note;
    emit(ComposeDetailsUpdateState());
  }

  void reorder(int oldIndex, newIndex) {
    notes.insert(newIndex, notes.removeAt(oldIndex));
    emit(ComposeDetailsUpdateState());
  }
}
