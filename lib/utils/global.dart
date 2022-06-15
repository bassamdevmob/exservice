import 'package:exservice/styles/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';

final navigatorKey = GlobalKey<NavigatorState>();

final currencyFormatter = NumberFormat.currency(name: "");
final expireDateFormatter = DateFormat("yyyyMM");
final expireDateUiFormatter = DateFormat("MM/yy");
final isoFormatter = DateFormat("dd MMM, y");
final sqlFormatter = DateFormat("y-M-d");
final dateFormatter = DateFormat("yyyy/MM/dd");
final jmTimeFormatter = DateFormat.jm();
final jmsTimeFormatter = DateFormat.jms();
final phoneRegex = RegExp(r'(^(?:[+0]9)?[0-9]{10,14}$)');

var swiperPagination = SwiperPagination(
  builder: DotSwiperPaginationBuilder(
    size: 5,
    activeSize: 10,
    color: AppColors.gray.withOpacity(0.8),
  ),
);