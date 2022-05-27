// import 'package:exservice/bloc/application_bloc/application_cubit.dart';
// import 'package:exservice/bloc/profile_bloc/profile_bloc.dart';
// import 'package:exservice/layout/auth/login_layout.dart';
// import 'package:exservice/localization/app_localization.dart';
// import 'package:exservice/styles/app_colors.dart';
// import 'package:exservice/utils/sizer.dart';
// import 'package:exservice/widget/application/global_widgets.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
// class DrawerLayout extends StatelessWidget {
//   final StackLoaderIndicator _loaderIndicator = StackLoaderIndicator();
//
//   DrawerLayout({Key key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     var iconSize = Sizer.iconSizeMedium;
//     var _bloc = BlocProvider.of<ProfileBloc>(context);
//     var isAuthenticated = _bloc.isAuthenticated;
//     return BlocListener<ProfileBloc, ProfileState>(
//       listener: (context, state) {
//         if (state is ProfileLogoutAwaitState) {
//           _loaderIndicator.show(context);
//         } else if (state is ProfileLogoutAcceptState) {
//           Fluttertoast.showToast(
//             msg: AppLocalization.of(context).translate("logged_out"),
//             toastLength: Toast.LENGTH_LONG,
//           );
//           BlocProvider.of<ApplicationCubit>(context).restart();
//         } else if (state is ProfileLogoutErrorState) {
//           _loaderIndicator.dismiss();
//           Fluttertoast.showToast(msg: state.error.toString());
//         }
//       },
//       child: Scaffold(
//         appBar: AppBar(),
//         body: ListView(
//           children: [
//             if (!isAuthenticated)
//               ListTile(
//                 leading: SvgPicture.asset(
//                   "assets/svg/user.svg",
//                   height: iconSize,
//                   width: iconSize,
//                 ),
//                 title: Text(
//                   AppLocalization.of(context).translate("guest"),
//                 ),
//                 trailing: Text(
//                   AppLocalization.of(context).translate("login"),
//                   style: Theme.of(context).primaryTextTheme.titleSmall,
//                 ),
//                 onTap: () {
//                   Navigator.of(context).push(
//                     CupertinoPageRoute(
//                       builder: (context) => BlocProvider(
//                         create: (context) => LoginBloc(),
//                         child: const LoginLayout(),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             if (isAuthenticated)
//               BlocBuilder<ProfileBloc, ProfileState>(
//                 buildWhen: (_, current) =>
//                 current is ProfileAcceptState ||
//                     current is ProfileUpdateAcceptState,
//                 builder: (context, state) {
//                   return ListTile(
//                     leading: SvgPicture.asset(
//                       "assets/svg/user.svg",
//                       height: iconSize,
//                       width: iconSize,
//                     ),
//                     title: getUserWidget(context),
//                     trailing: getTrailing(context),
//                     onTap: () {
//                       Navigator.of(context).push(
//                         CupertinoPageRoute(
//                           builder: (context) => const ProfileLayout(),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ListTile(
//               leading: SvgPicture.asset(
//                 "assets/svg/globe.svg",
//                 height: iconSize,
//                 width: iconSize,
//               ),
//               title: Text(
//                 AppLocalization.of(context).translate("change_language"),
//               ),
//               trailing: getTrailing(context),
//               onTap: () {
//                 Navigator.of(context).push(CupertinoPageRoute(
//                   builder: (context) => const ChangeLanguageLayout(),
//                 ));
//               },
//             ),
//             SwitchListTile(
//               secondary: SvgPicture.asset(
//                 "assets/svg/moon.svg",
//                 height: iconSize,
//                 width: iconSize,
//               ),
//               inactiveTrackColor: AppColors.gray,
//               title: Text(
//                 AppLocalization.of(context).translate("dark_mode"),
//               ),
//               value: DataStore.instance.isDarkModeEnabled,
//               onChanged: (bool value) {
//                 BlocProvider.of<ApplicationCubit>(context).switchTheme();
//               },
//             ),
//             ListTile(
//               leading: SvgPicture.asset(
//                 "assets/svg/file.svg",
//                 height: Sizer.iconSizeMedium,
//                 width: Sizer.iconSizeMedium,
//               ),
//               title: Text(
//                 AppLocalization.of(context).translate("about_us"),
//               ),
//               trailing: getTrailing(context),
//               onTap: () {
//                 Navigator.of(context).push(CupertinoPageRoute(
//                   builder: (context) => const AboutUsLayout(),
//                 ));
//               },
//             ),
//             ListTile(
//               leading: SvgPicture.asset(
//                 "assets/svg/mail1.svg",
//                 height: Sizer.iconSizeMedium,
//                 width: Sizer.iconSizeMedium,
//               ),
//               title: Text(
//                 AppLocalization.of(context).translate("contact_us"),
//               ),
//               trailing: getTrailing(context),
//               onTap: () {
//                 Navigator.of(context).push(CupertinoPageRoute(
//                   builder: (context) => BlocProvider(
//                     create: (context) => ContactUsBloc(),
//                     child: const ContactUsLayout(),
//                   ),
//                 ));
//               },
//             ),
//             ListTile(
//               leading: SvgPicture.asset(
//                 "assets/svg/alert.svg",
//                 height: Sizer.iconSizeMedium,
//                 width: Sizer.iconSizeMedium,
//               ),
//               title: Text(
//                 AppLocalization.of(context).translate("terms_condition"),
//               ),
//               trailing: getTrailing(context),
//               onTap: () {
//                 Navigator.of(context).push(CupertinoPageRoute(
//                   builder: (context) => InfoLayout(
//                     title: AppLocalization.of(context).translate("terms_condition"),
//                     content: faker.lorem.sentences(10).join("\n"),
//                   ),
//                 ));
//               },
//             ),
//             ListTile(
//               leading: SvgPicture.asset(
//                 "assets/svg/book.svg",
//                 height: Sizer.iconSizeMedium,
//                 width: Sizer.iconSizeMedium,
//               ),
//               title: Text(
//                 AppLocalization.of(context).translate("privacy_police"),
//               ),
//               trailing: getTrailing(context),
//               onTap: () {
//                 Navigator.of(context).push(CupertinoPageRoute(
//                   builder: (context) => InfoLayout(
//                     title: AppLocalization.of(context).translate("privacy_police"),
//                     content: faker.lorem.sentences(10).join("\n"),
//                   ),
//                 ));
//               },
//             ),
//             ListTile(
//               leading: SvgPicture.asset(
//                 Assets.svgShare,
//                 height: iconSize,
//                 width: iconSize,
//               ),
//               title: Text(
//                 AppLocalization.of(context).translate("share_app"),
//               ),
//               trailing: getTrailing(context),
//               onTap: () {},
//             ),
//             if (isAuthenticated)
//               ListTile(
//                 leading: SvgPicture.asset(
//                   Assets.svgLogout,
//                   height: iconSize,
//                   width: iconSize,
//                 ),
//                 title: Text(
//                   AppLocalization.of(context).translate("logout"),
//                 ),
//                 onTap: () {
//                   ActionBottomSheet.show(
//                     context,
//                     title: AppLocalization.of(context).translate("logout"),
//                     subtitle: AppLocalization.of(context).translate("logout_desc"),
//                     confirmText: AppLocalization.of(context).translate("logout"),
//                     onTap: () {
//                       BlocProvider.of<ProfileBloc>(context).logout();
//                     },
//                   );
//                 },
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget getUserWidget(BuildContext context) {
//     var subscriber = DataStore.instance.subscriber!;
//     return Text(
//       subscriber.name ?? subscriber.msisdn,
//     );
//   }
// }
