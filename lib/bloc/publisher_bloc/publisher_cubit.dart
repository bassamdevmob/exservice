import 'package:bloc/bloc.dart';
import 'package:exservice/models/entity/user.dart';
import 'package:exservice/resources/repository/ad_repository.dart';
import 'package:exservice/utils/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

part 'publisher_state.dart';

class PublisherCubit extends Cubit<PublisherState> {
  final int id;
  final scrollController = ScrollController();
  User publisher;

  @override
  Future<void> close() {
    scrollController.dispose();
    return super.close();
  }

  PublisherCubit(this.id) : super(PublisherAwaitState());

  Future<void> fetch() async {
    try {
      emit(PublisherAwaitState());
      var response = await GetIt.I.get<AdRepository>().publisher(id);
      publisher = response.data;
      emit(PublisherAcceptState());
    } catch (e) {
      emit(PublisherErrorState("$e"));
    }
  }
}
