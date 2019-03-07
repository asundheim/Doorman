import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gatekeeper/widgets/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../classes/user.dart';
import '../services/api_service.dart' as api;
import '../widgets/listloading.dart';
import './login.dart';

class Settings extends StatefulWidget {
  final String userID;
  const Settings({Key key, @required this.userID}): super(key: key);

  @override
  _SettingsState createState() => _SettingsState(userID: userID);
}

class _SettingsState extends State<Settings> {
  String userID;

  _SettingsState({@required this.userID}): super();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: api.userInfo(userID),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.hasData) {
          return settingsList(snapshot.data);
        } else {
          return ListLoading();
        }
      },
    );

  }

  Widget settingsList(User user) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text('Logged in with ${user.email}'),
            ),
            ListTile(
              title: const Text('Sign Out'),
              onTap: () => _signOut()
            )
          ],
        ),
      ),
    );
  }

  void _signOut() async {
    final ProgressDialog pr = ProgressDialog(
        context,
        loadingIndicator: SpinKitWave(color: Colors.deepPurple, type: SpinKitWaveType.start),
        progressDialogType: ProgressDialogType.Material,
        loadingIndicatorWidth: 62.5
    );
    pr.setMessage('Signing Out');
    pr.show();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    pr.hide();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute<Login>(builder: (BuildContext context) => Login()),
      ModalRoute.withName('/'),
    );
  }
}
