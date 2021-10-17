import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:exservice/renovation/models/common/ad_model.dart';
import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/resources/api/ApiProviderDelegate.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'edit_ad_event.dart';

part 'edit_ad_state.dart';

class EditAdBloc extends Bloc<EditAdEvent, EditAdState> {
  final AdModel ad;
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

  EditAdBloc(this.context, this.ad) : super(EditAdInitial()) {
    titleController.text = ad.title;
    descriptionController.text = ad.description;
    on<EditAdEvent>((event, emit) async {
      if (event is FetchEditAdEvent) {
        try {
          _validate();
          emit(EditAdValidationState());
          if (valid) {
            emit(EditAdAwaitState());
            String title = titleController.text.trim();
            String description = descriptionController.text.trim();
            await GetIt.I
                .get<ApiProviderDelegate>()
                .fetchEditAd(ad.id, title, description);
            ad.title = title;
            ad.description = description;
            emit(EditAdCommittedState());
          }
        } catch (e) {
          emit(EditAdErrorState("$e"));
        }
      }
    });
  }
}
