import 'package:exservice/renovation/bloc/view/account_bloc/account_bloc.dart';
import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/styles/app_colors.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:exservice/renovation/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_number/phone_number.dart';

class ContactInfoLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = BlocProvider.of<AccountBloc>(context).profile.user;
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        iconTheme: IconThemeData(color: AppColors.blue),
        centerTitle: true,
        title: Text(
          AppLocalization.of(context).trans("app_name"),
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
              AppLocalization.of(context).trans("email_desc"),
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
            onTap: () {},
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
                  snapshot.hasData ? snapshot.data.international : user.phoneNumber,
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
              AppLocalization.of(context).trans("phone_desc"),
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
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
