import 'dart:async';
import 'dart:io';

import 'package:exservice/styles/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/utils/sizer.dart';
import 'package:lottie/lottie.dart';

class EmptyIndicator extends StatelessWidget {
  final VoidCallback onTap;
  final bool hideIcon;

  const EmptyIndicator({
    Key key,
    this.onTap,
    this.hideIcon = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 3.h,
        horizontal: 10.w,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: getContentWidget(context),
      ),
    );
  }

  Widget getContentWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!hideIcon)
          Lottie.asset("assets/json/empty.json", width: 120, height: 120),
        const SizedBox(height: 10),
        Text(
          AppLocalization.of(context).translate("empty_list"),
          style: Theme.of(context).primaryTextTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          AppLocalization.of(context).translate("empty_list_desc"),
          style: Theme.of(context)
              .primaryTextTheme
              .bodyMedium
              .copyWith(color: AppColors.gray),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.blue,
          ),
          child: Icon(
            CupertinoIcons.refresh,
            size: 3.h,
          ),
        ),
      ],
    );
  }
}

class ReloadIndicator extends StatelessWidget {
  final dynamic error;
  final VoidCallback onTap;

  const ReloadIndicator({
    Key key,
    this.error,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 3.h,
        horizontal: 10.w,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Builder(builder: (context) {
          if (error is SocketException) return getSocketWidget(context);
          if (error is TimeoutException) return getTimeoutWidget(context);
          return getSimpleWidget(context, error);
        }),
      ),
    );
  }

  Widget getSimpleWidget(BuildContext context, error) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          error.toString(),
          style: Theme.of(context).primaryTextTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.blue,
          ),
          child: Icon(
            CupertinoIcons.refresh,
            size: 3.h,
          ),
        ),
      ],
    );
  }

  Widget getTimeoutWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppLocalization.of(context).translate("connection_timeout"),
          style: Theme.of(context).primaryTextTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          AppLocalization.of(context).translate("connection_timeout_desc"),
          style: Theme.of(context).primaryTextTheme.labelMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.blue,
          ),
          child: Icon(
            CupertinoIcons.refresh,
            size: 3.h,
          ),
        ),
      ],
    );
  }

  Widget getSocketWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Lottie.asset("assets/json/no_internet.json", width: 120, height: 120),
        const SizedBox(height: 10),
        Text(
          AppLocalization.of(context).translate("no_internet"),
          style: Theme.of(context).primaryTextTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          AppLocalization.of(context).translate("no_internet_desc"),
          style: Theme.of(context).primaryTextTheme.labelMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.blue,
          ),
          child: Icon(
            CupertinoIcons.refresh,
            size: 3.h,
          ),
        ),
      ],
    );
  }
}
