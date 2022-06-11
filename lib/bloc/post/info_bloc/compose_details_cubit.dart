import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:exservice/bloc/post/composition_repository.dart';
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
  final CompositionRepository repository;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  Config data;

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

  ComposeDetailsCubit(this.repository) : super(ComposeDetailsAwaitState()) {
    titleController.text = repository.title;
    descriptionController.text = repository.description;

    titleController.addListener(() {
      repository.title = titleController.text.trim();
    });
    descriptionController.addListener(() {
      repository.description = descriptionController.text.trim();
    });
  }

  void next() {
    _validate();
    emit(ComposeDetailsValidationState());
    if (valid) {
      if (repository.type == null) {
        emit(ComposeDetailsValidationErrorState(Localized("type_required")));
      } else if (repository.trade == null) {
        emit(ComposeDetailsValidationErrorState(Localized("trade_required")));
      } else if (repository.location == null) {
        emit(ComposeDetailsValidationErrorState(Localized("location_required")));
      } else if (repository.size == null) {
        emit(ComposeDetailsValidationErrorState(Localized("size_required")));
      } else if (repository.price == null) {
        emit(ComposeDetailsValidationErrorState(Localized("price_required")));
      } else {
        emit(ComposeDetailsNextState());
      }
    }
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
    repository.type = result;
    emit(ComposeDetailsUpdateState());
  }

  void updateTrade(OptionResult result) {
    repository.trade = result;
    emit(ComposeDetailsUpdateState());
  }

  void updatePosition(LatLng result) {
    repository.location = result;
    emit(ComposeDetailsUpdateState());
  }

  void updatePrice(NumericResult result) {
    repository.price = result;
    emit(ComposeDetailsUpdateState());
  }

  void updateSize(NumericResult result) {
    repository.size = result;
    emit(ComposeDetailsUpdateState());
  }

  void newNote() {
    repository.notes.add("");
    emit(ComposeDetailsUpdateState());
  }

  void removeNote(int index) {
    repository.notes.removeAt(index);
    emit(ComposeDetailsUpdateState());
  }

  void updateNote(int index, NoteResult result) {
    repository.notes[index] = result.note;
    emit(ComposeDetailsUpdateState());
  }

  void reorder(int oldIndex, newIndex) {
    repository.notes.insert(newIndex, repository.notes.removeAt(oldIndex));
    emit(ComposeDetailsUpdateState());
  }
}
