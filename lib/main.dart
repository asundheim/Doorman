import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './classes/loginresult.dart';
import './pages/home.dart';
import './pages/login.dart';
import './pages/splash.dart';
import './services/api_service.dart' as api;
import './services/auth_service.dart' as auth;

void main() => runApp(Main());

class Main extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gatekeeper',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => FutureBuilder<LoginResult>(
          future: attemptLogin(),
          builder: (BuildContext context, AsyncSnapshot<LoginResult> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.loginSuccess) {
                return Home(userID: auth.getUserID(snapshot.data.prefs));
              } else {
                return Login();
              }
            } else {
              return SplashScreen();
            }
          },
        ),
      },
    );
  }

  Future<LoginResult> attemptLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (auth.loginExists(prefs)) {
      final bool loginSuccess = await api.tokenLogin(prefs);
      return LoginResult(prefs: prefs, loginSuccess: loginSuccess);
    } else {
      return LoginResult(prefs: prefs, loginSuccess: false);
    }
  }
}
