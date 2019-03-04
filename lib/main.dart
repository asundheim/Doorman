import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './pages/home.dart';
import './pages/login.dart';
import './pages/splash.dart';
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
        '/': (BuildContext context) => FutureBuilder<SharedPreferences>(
          future: getStorageInstance(),
          builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
            if (snapshot.hasData) {
              if (auth.tokenExists(snapshot.data)) {
                return Home(userID: auth.getUserID(snapshot.data));
              } else {
                return Login();
              }
            } else {
              return SplashScreen();
            }
          },
        )
      },
    );
  }

  Future<SharedPreferences> getStorageInstance() async {
    return SharedPreferences.getInstance();
  }
}
