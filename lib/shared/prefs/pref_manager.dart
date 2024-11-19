import 'package:template/shared/models/user_model.dart';
import 'package:logger/logger.dart';

import 'pref_keys.dart';
import 'pref_utils.dart';

class PrefManager {
  static UserModel? currentUser;

  static Future init() async {
    /// User
    currentUser = await getCurrentUser();
  }

  /// SETTERS
  static Future setCurrentUser(UserModel? user) async {
    currentUser = user;
    await PrefUtils.setJson(PrefKeys.currentUser, user?.toJson());
  }

  static Future clearUserData() async {
    currentUser = null;
    await PrefUtils.setJson(PrefKeys.currentUser, null);
  }

  /// GETTERS
  static Future<UserModel?> getCurrentUser() async {
    Map<String, dynamic>? userData =
        await PrefUtils.getJson(PrefKeys.currentUser);
    UserModel? temp;
    if (userData != null) {
      temp = UserModel.fromJson(userData);
      Logger().d("user : ${temp.toJson()}");
    }
    return temp;
  }
}
