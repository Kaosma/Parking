import 'package:intl/intl.dart';

String convertUnixToDateTime(unixTimestamp) {
  final formatter = DateFormat('yyyy/MM/dd HH:mm');

  return formatter
      .format(DateTime.fromMillisecondsSinceEpoch(unixTimestamp * 1000))
      .toString();
}
