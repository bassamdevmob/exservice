import 'package:exservice/bloc/account/switch_business_bloc/switch_business_bloc.dart';
import 'package:exservice/bloc/view/account_bloc/account_bloc.dart';
import 'package:exservice/layout/account/switch_business_layout.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomeBusinessLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.read<AccountBloc>().profile;
    var _mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          backgroundImage:
                              AssetImage('assets/images/ic_user.png'),
                        ),
                      ),
                      SizedBox(height: _mediaQuery.size.height * 0.06),
                      Text(
                        "${AppLocalization.of(context).translate('welcomeToBusiness')}, ${user.username}",
                        style: AppTextStyle.xxLargeBlack,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: _mediaQuery.size.height * 0.04,
                    ),
                    child: ElevatedButton(
                      child: Text(
                        AppLocalization.of(context).translate('continue'),
                        style: AppTextStyle.mediumWhite,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => SwitchBusinessBloc(context),
                              child: SwitchBusinessLayout(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
