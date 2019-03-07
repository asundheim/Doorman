import 'package:shared_preferences/shared_preferences.dart';

class LoginResult {
  SharedPreferences prefs;
  bool loginSuccess;

  LoginResult({this.prefs, this.loginSuccess});
}