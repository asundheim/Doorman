import 'package:shared_preferences/shared_preferences.dart';

class SettingsData {
  SharedPreferences prefs;
  String email;

  SettingsData({this.prefs, this.email});
}