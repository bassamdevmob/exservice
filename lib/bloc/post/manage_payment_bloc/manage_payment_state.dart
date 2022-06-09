part of 'manage_payment_cubit.dart';

@immutable
abstract class ManagePaymentState {}

class ManagePaymentAwaitState extends ManagePaymentState {}

class ManagePaymentAcceptState extends ManagePaymentState {}

class ManagePaymentErrorState extends ManagePaymentState {
  final dynamic error;

  ManagePaymentErrorState(this.error);
}

class ManagePaymentPayAwaitState extends ManagePaymentState {}

class ManagePaymentPayAcceptState extends ManagePaymentState {
  final PaymentResult result;

  ManagePaymentPayAcceptState(this.result);
}

class ManagePaymentPayErrorState extends ManagePaymentState {
  final dynamic error;

  ManagePaymentPayErrorState(this.error);
}
