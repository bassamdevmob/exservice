import 'package:exservice/bloc/manage_payment_bloc/manage_payment_cubit.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/widget/application/reload_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManagePaymentLayout extends StatefulWidget {
  const ManagePaymentLayout({Key key}) : super(key: key);

  @override
  _ManagePaymentLayoutState createState() => _ManagePaymentLayoutState();
}

class _ManagePaymentLayoutState extends State<ManagePaymentLayout> {
  ManagePaymentCubit _bloc;

  @override
  void initState() {
    _bloc = context.read<ManagePaymentCubit>();
    _bloc.fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<ManagePaymentCubit, ManagePaymentState>(
        buildWhen: (previous, current) =>
            current is ManagePaymentAwaitState ||
            current is ManagePaymentErrorState ||
            current is ManagePaymentAcceptState,
        builder: (context, state) {
          if (state is ManagePaymentAwaitState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ManagePaymentErrorState) {
            return Center(
              child: ReloadIndicator(
                error: state.error,
                onTap: () {
                  _bloc.fetch();
                },
              ),
            );
          }
          return Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                AppLocalization.of(context).translate("pricesDuration"),
              ),
              ListTile(
                title: Text(AppLocalization.of(context).translate("")),
                subtitle: Text(
                  "${AppLocalization.of(context).translate("cost")}: ${_bloc.data.cost} ${_bloc.data.currency}",
                ),
              ),
              ListTile(
                title: Text(AppLocalization.of(context).translate("")),
                subtitle: Text(
                  "${AppLocalization.of(context).translate("cost")}: ${_bloc.data.cost} ${_bloc.data.currency}",
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: _bloc.controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  decoration: InputDecoration(
                    labelText: AppLocalization.of(context).translate("amount"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: BlocBuilder<ManagePaymentCubit, ManagePaymentState>(
                  buildWhen: (previous, current) =>
                      current is ManagePaymentPayAwaitState ||
                      current is ManagePaymentPayErrorState ||
                      current is ManagePaymentPayAcceptState,
                  builder: (context, state) {
                    return ElevatedButton(
                      child: state is ManagePaymentPayAwaitState
                          ? CupertinoActivityIndicator()
                          : Text(
                              AppLocalization.of(context).translate("pay"),
                            ),
                      onPressed: state is ManagePaymentPayAwaitState
                          ? null
                          : () {
                              _bloc.submit();
                            },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
