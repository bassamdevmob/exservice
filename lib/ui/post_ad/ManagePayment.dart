// import 'dart:async';
//
// import 'package:exservice/bloc/StatePusher.dart';
// import 'package:exservice/models/options/AdPricesListModel.dart';
// import 'package:exservice/bloc/application_bloc/application_cubit.dart';
// import 'package:exservice/localization/app_localization.dart';
// import 'package:exservice/styles/app_colors.dart';
// import 'package:exservice/styles/app_text_style.dart';
// import 'package:exservice/widget/application/reload_widget.dart';
// import 'package:exservice/widget/button/app_button.dart';
// import 'package:exservice/resources/api/ApiProviderDelegate.dart';
// import 'package:exservice/ui/post_ad/PaymentWebView.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get_it/get_it.dart';
// import 'package:numberpicker/numberpicker.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class ManagePaymentModel {
//   final notifier = StatePusher.publish();
//   List<AdPrice> paymentOptions;
//   AdPrice groupValue;
//
//   int cost = 0;
//   int days = 1;
//   bool loading = false;
//   bool submitting = false;
//
//   Future<void> fetchPaymentsOptions(BuildContext context) async {
//     loading = true;
//     notifier.push();
//     try {
//       paymentOptions =
//           await GetIt.I.get<ApiProviderDelegate>().fetchAdPricesList(context);
//       groupValue = paymentOptions.first;
//       cost = groupValue.value * days;
//       loading = false;
//       notifier.push();
//     } catch (e) {
//       loading = false;
//       notifier.pushError(e.toString());
//     }
//   }
//
//   Future<void> submitPayment(context, adId) async {
//     submitting = true;
//     notifier.push();
//     try {
//       final url = await GetIt.I
//           .get<ApiProviderDelegate>()
//           .fetchPayment(context, adId, groupValue.id, days);
//       submitting = false;
//       notifier.push();
//       if (await canLaunch(url)) {
//         Navigator.of(context).push(CupertinoPageRoute(
//           builder: (context) => PaymentWebView(url),
//         ));
//       } else {
//         Fluttertoast.showToast(
//           msg: "${AppLocalization.of(context).trans("siteFailed")}: $url",
//         );
//       }
//       // Utils.launchWeb(context, res);
//     } catch (e) {
//       submitting = false;
//       notifier.pushError(e.toString());
//     }
//   }
//
//   void dispose() {
//     notifier.dispose();
//   }
// }
//
// class ManagePayment extends StatefulWidget {
//   final int id;
//
//   const ManagePayment(this.id, {Key key}) : super(key: key);
//
//   @override
//   _ManagePaymentState createState() => _ManagePaymentState();
// }
//
// class _ManagePaymentState extends State<ManagePayment> {
//   ManagePaymentModel _model = ManagePaymentModel();
//
//   @override
//   void initState() {
//     super.initState();
//     _model.fetchPaymentsOptions(context);
//   }
//
//   @override
//   void dispose() {
//     _model.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async => false,
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: AppColors.white,
//           iconTheme: IconThemeData(color: AppColors.blue),
//           centerTitle: true,
//           title: Text(
//             AppLocalization.of(context).trans('app_name'),
//             style: AppTextStyle.largeBlack,
//           ),
//         ),
//         body: StreamBuilder(
//           stream: _model.notifier.stream,
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               return Center(
//                 child: ReloadWidget.error(
//                   content: Text(
//                     snapshot.error.toString(),
//                     textAlign: TextAlign.center,
//                   ),
//                   onPressed: () {
//                     _model.fetchPaymentsOptions(context);
//                   },
//                 ),
//               );
//             }
//             if (_model.loading) {
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//             if (_model.paymentOptions == null ||
//                 _model.paymentOptions.isEmpty) {
//               return Center(
//                 child: ReloadWidget.empty(
//                   content: Text(
//                     AppLocalization.of(context).trans('noData'),
//                     textAlign: TextAlign.center,
//                   ),
//                   onPressed: () {
//                     _model.fetchPaymentsOptions(context);
//                   },
//                 ),
//               );
//             }
//             return Column(
//               children: [
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   AppLocalization.of(context).trans("pricesDuration"),
//                   style: AppTextStyle.largeBlackBold,
//                 ),
//                 Expanded(
//                   child: ListView.separated(
//                     separatorBuilder: (context, index) => Divider(
//                       color: AppColors.black,
//                       height: 1,
//                     ),
//                     itemCount: _model.paymentOptions.length,
//                     itemBuilder: (context, index) {
//                       return RadioListTile(
//                         title: Text(_model.paymentOptions[index].name),
//                         subtitle: Text(
//                           "${AppLocalization.of(context).trans("cost")}: ${_model.paymentOptions[index].value} ${_model.paymentOptions[index].currency}",
//                         ),
//                         value: _model.paymentOptions[index],
//                         groupValue: _model.groupValue,
//                         onChanged: (option) {
//                           _model.groupValue = option;
//                           _model.notifier.push();
//                         },
//                       );
//                     },
//                   ),
//                 ),
//                 Divider(),
//                 Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: NumberPicker(
//                     value: _model.days,
//                     minValue: 1,
//                     maxValue: 30,
//                     onChanged: (val) {
//                       _model.days = val;
//                       _model.cost = _model.groupValue.value * val;
//                       _model.notifier.push();
//                     },
//                   ),
//                   // child: TextFormField(
//                   //   keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
//                   //   decoration: InputDecoration(hintText: "Card Holder Name"),
//                   //   // controller: _cardModel.cardHolderNameController,
//                   // ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Text(
//                     "${AppLocalization.of(context).trans("cost")}: ${_model.cost} ${_model.groupValue.currency}",
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: AppButton(
//                     child: _model.submitting
//                         ? CupertinoActivityIndicator()
//                         : Text(
//                             AppLocalization.of(context).trans("pay"),
//                             style: AppTextStyle.largeBlack,
//                           ),
//                     onTap: () => _model.submitPayment(context, widget.id),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: AppButton(
//                     child: Text(
//                       AppLocalization.of(context).trans("done"),
//                       style: AppTextStyle.largeBlack,
//                     ),
//                     onTap: () =>
//                         BlocProvider.of<ApplicationCubit>(context).refresh(),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_credit_card/flutter_credit_card.dart';
// // import 'package:exservice/localization/app_localization.dart';
// // import 'package:exservice/bloc/StatePusher.dart';
// // import 'package:exservice/styles/app_colors.dart';
// // import 'package:exservice/styles/app_text_style.dart';
// // import 'package:exservice/widget/application/HelperWidgets.dart';
// //
// // class CreditCardModel {
// //   bool showBack = false;
// //
// //   final FocusNode cvvFocusNode = FocusNode();
// //   final TextEditingController cardNumberController = MaskedTextController(mask: '0000 0000 0000 0000');
// //   final TextEditingController expiryDateController = MaskedTextController(mask: '00/00');
// //   final TextEditingController cardHolderNameController = TextEditingController();
// //   final TextEditingController cvvCodeController = MaskedTextController(mask: '0000');
// //   final StatePusher _pusher = StatePusher<Null>.publish();
// //
// //   Stream get stream => _pusher.stream;
// //
// //   void _textFieldFocusDidChange() {
// //     showBack = cvvFocusNode.hasFocus;
// //     _pusher.push();
// //   }
// //
// //   CreditCardModel() {
// //     cvvFocusNode.addListener(_textFieldFocusDidChange);
// //
// //     cardNumberController.addListener(_pusher.push);
// //
// //     expiryDateController.addListener(_pusher.push);
// //
// //     cardHolderNameController.addListener(_pusher.push);
// //
// //     cvvCodeController.addListener(_pusher.push);
// //   }
// //
// //   void dispose() {
// //     cvvFocusNode.removeListener(_textFieldFocusDidChange);
// //
// //     cardNumberController.dispose();
// //
// //     expiryDateController.dispose();
// //
// //     cardHolderNameController.dispose();
// //
// //     cvvCodeController.dispose();
// //
// //     cvvFocusNode.dispose();
// //
// //     _pusher.dispose();
// //   }
// // }
// //
// // class PayPalModel {
// //   final TextEditingController email = TextEditingController();
// //   final TextEditingController password = TextEditingController();
// //
// //   void dispose() {
// //     email.dispose();
// //     password.dispose();
// //   }
// // }
// //
// // class ManagePayment extends StatefulWidget {
// //   @override
// //   _ManagePaymentState createState() => _ManagePaymentState();
// // }
// //
// // class _ManagePaymentState extends State<ManagePayment> {
// //   final _cardModel = CreditCardModel();
// //   final _payPalModel = PayPalModel();
// //   final _submitPusher = StatePusher<Null>.publish();
// //   bool _loading = false;
// //
// //   @override
// //   void dispose() {
// //     _cardModel.dispose();
// //     _payPalModel.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return DefaultTabController(
// //       length: 2,
// //       child: Scaffold(
// //         bottomNavigationBar: BottomAppBar(
// //           child: StreamBuilder<Null>(
// //             stream: _submitPusher.stream,
// //             builder: (context, snapshot) {
// //               bool valid = true;
// //               return Padding(
// //                 padding: const EdgeInsets.all(8.0),
// //                 child: RaisedButton(
// //                   child: Padding(
// //                     padding: const EdgeInsets.all(12.0),
// //                     child: _loading
// //                         ? CupertinoActivityIndicator()
// //                         : Text(
// //                             AppLocalization.of(context).trans('publish'),
// //                             style: AppTextStyle.mediumWhite,
// //                           ),
// //                   ),
// //                   color: AppColors.blue,
// //                   onPressed: _loading || !valid ? null : (){},
// //                 ),
// //               );
// //             },
// //           ),
// //         ),
// //         appBar: PreferredSize(
// //           preferredSize: Size.fromHeight(85),
// //           child: AppBar(
// //             backgroundColor: AppColors.white,
// //             iconTheme: IconThemeData(color: AppColors.blue),
// //             centerTitle: true,
// //             title: Text(
// //               AppLocalization.of(context).trans('app_name'),
// //               style: AppTextStyle.largeBlack,
// //             ),
// //             bottom: TabBar(
// //               tabs: <Widget>[
// //                 Tab(
// //                   child: Text(
// //                     "PayPal",
// //                     style: AppTextStyle.largeBlue,
// //                   ),
// //                 ),
// //                 Tab(
// //                   child: Text(
// //                     "Credit Card",
// //                     style: AppTextStyle.largeBlue,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //         body: TabBarView(
// //           children: <Widget>[
// //             SingleChildScrollView(
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.start,
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: <Widget>[
// //                   Container(
// //                     margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
// //                     child: TextFormField(
// //                       decoration: InputDecoration(
// //                         hintText: AppLocalization.of(context).trans("email2"),
// //                       ),
// //                       maxLines: 1,
// //                       controller: _payPalModel.email,
// //                     ),
// //                   ),
// //                   Container(
// //                     margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
// //                     child: TextFormField(
// //                       decoration: InputDecoration(
// //                         hintText: AppLocalization.of(context).trans("password"),
// //                       ),
// //                       obscureText: true,
// //                       maxLines: 1,
// //                       controller: _payPalModel.password,
// //                     ),
// //                   )
// //                 ],
// //               ),
// //             ),
// //             SingleChildScrollView(
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.start,
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: <Widget>[
// //                   StreamBuilder<Null>(
// //                     stream: _cardModel.stream,
// //                     builder: (context, snapshot) {
// //                       return CreditCardWidget(
// //                         cardNumber: _cardModel.cardNumberController.text,
// //                         expiryDate: _cardModel.expiryDateController.text,
// //                         cardHolderName: _cardModel.cardHolderNameController.text,
// //                         cvvCode: _cardModel.cvvCodeController.text,
// //                         showBackView: _cardModel.showBack,
// //                         cardBgColor: AppColors.blue,
// //                       );
// //                     },
// //                   ),
// //                   Container(
// //                     margin: EdgeInsets.symmetric(
// //                       horizontal: 20,
// //                     ),
// //                     child: TextFormField(
// //                       decoration: InputDecoration(hintText: "Card Number"),
// //                       maxLength: 19,
// //                       controller: _cardModel.cardNumberController,
// //                     ),
// //                   ),
// //                   Container(
// //                     margin: EdgeInsets.symmetric(
// //                       horizontal: 20,
// //                     ),
// //                     child: TextFormField(
// //                       decoration: InputDecoration(hintText: "Card Expiry"),
// //                       maxLength: 5,
// //                       controller: _cardModel.expiryDateController,
// //                     ),
// //                   ),
// //                   Container(
// //                     margin: EdgeInsets.symmetric(
// //                       horizontal: 20,
// //                     ),
// //                     child: TextFormField(
// //                       decoration: InputDecoration(hintText: "Card Holder Name"),
// //                       controller: _cardModel.cardHolderNameController,
// //                     ),
// //                   ),
// //                   Container(
// //                     margin: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
// //                     child: TextFormField(
// //                       decoration: InputDecoration(hintText: "CVV"),
// //                       maxLength: 3,
// //                       controller: _cardModel.cvvCodeController,
// //                       focusNode: _cardModel.cvvFocusNode,
// //                     ),
// //                   )
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
