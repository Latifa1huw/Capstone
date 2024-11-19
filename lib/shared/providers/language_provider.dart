import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _appLocale = const Locale("en");
  String _appLanguage = "en";

  // return the appLocale, if not supported make "en" by default
  Locale get appLocale {
    fetchLocale();
    return _appLocale;
  }

  String get appLanguage => _appLanguage;

  bool get isArabicAppLanguage => _appLanguage == 'en';

  fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('language_code') == null) {
      _appLocale = const Locale('en');
      return null;
    }

    _appLocale = Locale(prefs.getString('language_code')!);
    _appLanguage = prefs.getString('language_code')!;
    //print('Current Language is ' + _appLocale.languageCode);

    notifyListeners();
  }

  void changeLanguage(Locale type) async {
    var prefs = await SharedPreferences.getInstance();

    if (type == const Locale('ar')) {
      _appLocale = const Locale('ar');
      _appLanguage = "ar";
      prefs.setString('language_code', 'ar');
      prefs.setString('countryCode', '');
    } else {
      _appLocale = const Locale('en');
      _appLanguage = "en";
      prefs.setString('language_code', 'en');
      prefs.setString('countryCode', 'US');
    }

    Logger().d('Language Changed To ${prefs.getString('language_code')}');

    notifyListeners();
  }
}
