import 'package:intl/intl.dart';

extension DateExtensions on String {
  // String formatDate({String format = 'yyyy/MM/dd', String? local}) {
  //   final dateFormatter = DateFormat(format, local);
  //   return dateFormatter.format(this);
  // }

  String get formatDate => DateFormat.yMMMd().format( DateTime.fromMillisecondsSinceEpoch(int.parse(toString()) * 1000)).toString();
  // bool _isMinimumDate() => compareTo(DateTime.parse('0001-01-01T00:00:00')) == 0;
}
