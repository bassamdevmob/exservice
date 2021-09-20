import 'package:bloc/bloc.dart';
import 'package:exservice/helper/Enums.dart';
import 'package:exservice/models/GetUserProfileModel.dart';
import 'package:exservice/resources/api/ApiProviderDelegate.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'publisher_state.dart';

class PublisherCubit extends Cubit<PublisherState> {
  final int id;
  final scrollController = ScrollController();
  DisplayFormat format = DisplayFormat.list;
  UserProfile publisher;

  @override
  Future<void> close() {
    scrollController.dispose();
    return super.close();
  }

  PublisherCubit(this.id) : super(PublisherAwaitState());

  void changeFormat(DisplayFormat format) {
    if (this.format == format) return;
    this.format = format;
    if (scrollController.hasClients)
      scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    emit(PublisherChangeFormatState());
  }

  Future<void> fetch() async {
    try {
      emit(PublisherAwaitState());
      publisher =
          await GetIt.I.get<ApiProviderDelegate>().fetchGetUserAccount(id);
      emit(PublisherReceivedState());
    } catch (e) {
      emit(PublisherErrorState("$e"));
    }
  }
}
