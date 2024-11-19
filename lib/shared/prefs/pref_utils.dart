import 'dart:convert';
import 'package:template/shared/extentions/optional_strings_extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefUtils {
  static Future<SharedPreferences> getSharedPref() async {
    return await SharedPreferences.getInstance();
  }

  static Future clearSharedPrefKey(String key) async {
    return (await getSharedPref()).remove(key);
  }

  static Future<bool> setJson(String key, Map<String, dynamic>? data) async {
    String jsonData = jsonEncode(data);
    return (await getSharedPref()).setString(key, jsonData);
  }

  static Future<Map<String, dynamic>?> getJson(String key) async {
    String? temp = (await getSharedPref()).getString(key);
    return temp.isNullOrEmpty ? null : jsonDecode(temp!);
  }

  static Future<bool> setString(String key, String data) async {
    return (await getSharedPref()).setString(key, data);
  }

  static Future<String> getString(String key) async {
    return (await getSharedPref()).getString(key) ?? "";
  }

  static Future<bool> setInt(String key, int data) async {
    return (await getSharedPref()).setInt(key, data);
  }

  static Future<int> getInt(String key) async {
    return (await getSharedPref()).getInt(key) ?? 0;
  }

  static Future<bool> setBool(String key, bool data) async {
    return (await getSharedPref()).setBool(key, data);
  }

  static Future<bool?> getBool(String key) async {
    var result = (await getSharedPref()).getBool(key);
    return result;
  }
}
