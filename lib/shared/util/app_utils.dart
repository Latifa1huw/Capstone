import 'dart:convert';
import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

class AppUtils {
  static String toBase64(File file) {
    List<int> imageBytes = file.readAsBytesSync();
    return base64Encode(imageBytes);
  }

  static DateTime toDateTime(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
      timestamp * 1000,
    );
    return dateTime;
  }

  static void callPhone({required String phone}) async {
    final uri = Uri.parse('tel:$phone');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
