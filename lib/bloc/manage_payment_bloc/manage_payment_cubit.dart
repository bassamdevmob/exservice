import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:exservice/models/response/payment_package_response.dart';
import 'package:exservice/models/response/payment_response.dart';
import 'package:exservice/resources/repository/ad_repository.dart';
import 'package:exservice/resources/repository/config_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

part 'manage_payment_state.dart';

class ManagePaymentCubit extends Cubit<ManagePaymentState> {
  final TextEditingController controller = TextEditingController();
  Data data;
  int days = 0;

  ManagePaymentCubit() : super(ManagePaymentAwaitState());

  @override
  Future<void> close() {
    controller.dispose();
    return super.close();
  }

  Future<void> fetch() async {
    try {
      emit(ManagePaymentAwaitState());
      var response = await GetIt.I.get<ConfigRepository>().paymentInfo();
      data = response.data;
      emit(ManagePaymentAcceptState());
    } on DioError catch (ex) {
      emit(ManagePaymentErrorState(ex.error));
    }
  }

  Future<void> submit() async {
    try {
      emit(ManagePaymentPayAwaitState());
      var response = await GetIt.I.get<AdRepository>().pay(days);
      emit(ManagePaymentPayAcceptState(response.data));
    } on DioError catch (ex) {
      emit(ManagePaymentPayErrorState(ex.error));
    }
  }

}
