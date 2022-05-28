import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:exservice/resources/api_client.dart';
import 'package:exservice/resources/repository/user_repository.dart';
import 'package:exservice/utils/localized.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

part 'contact_us_event.dart';

part 'contact_us_state.dart';

class ContactUsBloc extends Bloc<ContactUsEvent, ContactUsState> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  Future<void> close() {
    titleController.dispose();
    contentController.dispose();
    return super.close();
  }

  Localized titleMessage;
  Localized contentMessage;

  void _validate() {
    String title = titleController.text.trim();
    String content = contentController.text.trim();

    titleMessage = title.isEmpty
        ? Localized("filed_required")
        : null;

    contentMessage = content.isEmpty
        ? Localized("filed_required")
        : null;
  }

  bool get isValid => titleMessage == null && contentMessage == null;

  ContactUsBloc() : super(ContactUsInitial()) {
    on<ContactUsEvent>((event, emit) async {
      if (event is ContactUsCommitEvent) {
        _validate();
        emit(ContactUsValidationState());
        if (isValid) {
          emit(ContactUsAwaitState());
          try {
            var response = await GetIt.I.get<UserRepository>().contactUs(
                  titleController.text.trim(),
                  contentController.text.trim(),
                );
            emit(ContactUsAcceptState());
          } on ValidationException catch (e) {
            var errors = e.errors;
            titleMessage = errors['title']?.join(" ");
            contentMessage = errors['content']?.join(" ");
            emit(ContactUsValidationState());
          } catch (e) {
            emit(ContactUsErrorState("$e"));
          }
        }
      }
    });
  }
}
