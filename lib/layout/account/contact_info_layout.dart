import 'package:exservice/bloc/account/manage_email_address_bloc/manage_email_address_bloc.dart';
import 'package:exservice/bloc/account/manage_phone_number_bloc/manage_phone_number_bloc.dart';
import 'package:exservice/bloc/view/account_bloc/account_bloc.dart';
import 'package:exservice/layout/account/edit/manage_email_address_layout.dart';
import 'package:exservice/layout/account/edit/manage_phone_number_layout.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:exservice/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_number/phone_number.dart';

class ContactInfoLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = BlocProvider.of<AccountBloc>(context).profile;
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        iconTheme: IconThemeData(color: AppColors.blue),
        centerTitle: true,
        title: Text(
          AppLocalization.of(context).translate("app_name"),
          style: AppTextStyle.largeLobsterBlack,
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.blueAccent,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.email,
                  color: AppColors.white,
                ),
              ),
            ),
            title: Text(
              user.email,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              AppLocalization.of(context).translate("email_desc"),
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(color: AppColors.gray),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_outlined,
              size: Utils.iconSize(mediaQuery),
              color: AppColors.blue,
            ),
            onTap: () {
              Navigator.of(context).push(CupertinoPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => ManageEmailAddressBloc(context),
                  child: ManageEmailAddressLayout(),
                ),
              ));
            },
          ),
          Divider(color: AppColors.deepGray, endIndent: 20, indent: 20),
          ListTile(
            leading: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.blueAccent,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.phone,
                  color: AppColors.white,
                ),
              ),
            ),
            title: FutureBuilder<PhoneNumber>(
              future: Utils.formatPhoneNumber(user.phoneNumber),
              builder: (context, snapshot) {
                return Text(
                  snapshot.hasData
                      ? snapshot.data.international
                      : user.phoneNumber,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                );
              },
            ),
            subtitle: Text(
              AppLocalization.of(context).translate("phone_desc"),
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(color: AppColors.gray),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_outlined,
              size: Utils.iconSize(mediaQuery),
              color: AppColors.blue,
            ),
            onTap: () {
              Navigator.of(context).push(CupertinoPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => ManagePhoneNumberBloc(context),
                  child: ManagePhoneNumberLayout(),
                ),
              ));
            },
          ),
        ],
      ),
    );
  }
}
