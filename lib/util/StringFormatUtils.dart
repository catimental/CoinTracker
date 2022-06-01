import 'package:intl/intl.dart';

class StringFormatUtils {
  static String formatKRW(double krw) {
    return "${NumberFormat('###,###,###,###').format((krw)?.round()).replaceAll(' ', '')}원";
  }
}
