// import 'package:exservice/localization/app_localization.dart';
// import 'package:exservice/utils/sizer.dart';
// import 'package:exservice/utils/utils.dart';
// import 'package:exservice/widget/application/global_widgets.dart';
// import 'package:flutter/material.dart';
//
// class OptionPickerBottomSheet<T> extends StatelessWidget {
//   final String Function(T) textBuilder;
//   final List<T> elements;
//
//   static Future<T> show<T>(
//     BuildContext context, {
//     List<T> elements,
//     String Function(T) textBuilder,
//   }) {
//     return showModalBottomSheet<T>(
//       context: context,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(35),
//       ),
//       backgroundColor: Colors.transparent,
//       builder: (context) => OptionPickerBottomSheet<T>(
//         elements: elements,
//         textBuilder: textBuilder,
//       ),
//     );
//   }
//
//   const OptionPickerBottomSheet({
//     Key key,
//     this.textBuilder,
//     this.elements,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     var mediaQuery = MediaQuery.of(context);
//     return Material(
//       child: ListView(
//         padding: const EdgeInsets.symmetric(
//           horizontal: 20,
//           vertical: 20,
//         ),
//         shrinkWrap: true,
//         children: [
//           SizedBox(height: Sizer.vs2),
//           BottomSheetStroke(),
//           SizedBox(height: Sizer.vs2),
//           Text(
//             AppLocalization.of(context).translate("choose_option"),
//             style: Theme.of(context).textTheme.headline3,
//           ),
//           SizedBox(height: Sizer.vs2),
//           Material(
//             child: Wrap(
//               alignment: WrapAlignment.spaceAround,
//               spacing: 10,
//               children: [
//                 for (var element in elements)
//                   InputChip(
//                     label: Text(textBuilder(element)),
//                     onPressed: () {
//                       Navigator.of(context).pop(element);
//                     },
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
