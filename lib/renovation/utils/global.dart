import 'package:intl/intl.dart';

final currencyFormatter = NumberFormat.currency(name: "");
final expireDateFormatter = DateFormat("yyyyMM");
final expireDateUiFormatter = DateFormat("MM/yy");
final isoFormatter = DateFormat("dd MMM, y");
final sqlFormatter = DateFormat("y-M-d");
final dateFormatter = DateFormat("yyyy/MM/dd");
final jmTimeFormatter = DateFormat.jm();
final jmsTimeFormatter = DateFormat.jms();
final phoneRegex = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
