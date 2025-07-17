import 'package:shared_preferences/shared_preferences.dart';

class LocalData {
  static late SharedPreferences prefs;

  static Future<void> initLocalService() async {
    prefs = await SharedPreferences.getInstance();
  }
}
