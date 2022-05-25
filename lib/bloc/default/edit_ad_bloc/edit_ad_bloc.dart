import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:exservice/models/entity/ad_model.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/models/request/edit_ad_request.dart';
import 'package:exservice/resources/repository/ad_repository.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

part 'edit_ad_event.dart';

part 'edit_ad_state.dart';

class EditAdBloc extends Bloc<EditAdEvent, EditAdState> {
  final AdModel model;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final BuildContext context;

  String titleErrorMessage;
  String descriptionErrorMessage;

  bool get valid =>
      titleErrorMessage == null && descriptionErrorMessage == null;

  void _validate() {
    String title = titleController.text.trim();
    String description = descriptionController.text.trim();

    titleErrorMessage = title.isEmpty
        ? AppLocalization.of(context).trans("filed_required")
        : null;

    descriptionErrorMessage = description.isEmpty
        ? AppLocalization.of(context).trans("filed_required")
        : null;
  }

  @override
  Future<void> close() {
    titleController.dispose();
    descriptionController.dispose();
    return super.close();
  }

  EditAdBloc(this.context, this.model) : super(EditAdInitial()) {
    titleController.text = model.title;
    descriptionController.text = model.description;
    on<EditAdEvent>((event, emit) async {
      if (event is FetchEditAdEvent) {
        try {
          _validate();
          emit(EditAdValidationState());
          if (valid) {
            emit(EditAdAwaitState());
            String title = titleController.text.trim();
            String description = descriptionController.text.trim();
            var response = await GetIt.I.get<AdRepository>().editAd(
                  model.id,
                  EditAdRequest(
                    title: title,
                    description: description,
                  ),
                );
            model.title = title;
            model.description = description;
            emit(EditAdCommittedState());
          }
        } catch (e) {
          emit(EditAdErrorState("$e"));
        }
      }
    });
  }
}
