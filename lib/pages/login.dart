import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart' as api;
import '../widgets/progress_dialog.dart';
import './home.dart';
import './create_account.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Icon _emailValid = Icon(Icons.clear, color: Colors.red[300]);
  Icon _passwordValid = Icon(Icons.clear, color: Colors.red[300]);
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(60.0),
              child: Center(
                child: Text(
                  'Login',
                  style: Theme.of(context).textTheme.display1,
                ),
              )
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  icon: const Icon(Icons.person, color: Colors.grey),
                  suffixIcon: _emailValid,
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: _emailValid.color)
                  ),
                ),
                onChanged: (String value) =>
                    setState(() =>
                      _emailValid = value.isEmpty ?
                        Icon(Icons.clear, color: Colors.red[300]) :
                        Icon(Icons.check, color: Colors.green[300])
                    )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  icon: const Icon(Icons.vpn_key, color: Colors.grey),
                  suffixIcon: _passwordValid,
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: _passwordValid.color)
                  ),
                ),
                obscureText: true,
                onChanged: (String value) =>
                    setState(() =>
                      _passwordValid = value.isEmpty ?
                        Icon(Icons.clear, color: Colors.red[300]) :
                        Icon(Icons.check, color: Colors.green[300])
                    )
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24.0, bottom: 12.0),
              child: Center(
                child: RaisedButton(
                  child: const Text('Login'),
                  onPressed: () => _login(),
                ),
              )
            ),
            Center(
              child: const Text('Or'),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: RaisedButton(
                  child: const Text('Create Account'),
                  color: Colors.deepPurple[300],
                  onPressed: () => _createAccount()
                ),
              )
            )
          ],
        ),
      ),
    );
  }

  void _createAccount() {
    Navigator.push(
        context, MaterialPageRoute<CreateAccount>(
        builder: (BuildContext context) => CreateAccount())
    );
  }

  void _login() async {
    final ProgressDialog pr = ProgressDialog(
        context,
        loadingIndicator: SpinKitWave(color: Colors.deepPurple, type: SpinKitWaveType.start),
        progressDialogType: ProgressDialogType.Material,
        loadingIndicatorWidth: 62.5
    );
    pr.setMessage('Attempting Login');
    pr.show();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (await api.login(_emailController.text, _passwordController.text, prefs)) {
      pr.hide();
      final String userID = prefs.getString('userID');
      Navigator.push(
          context, MaterialPageRoute<Home>(
          builder: (BuildContext context) => Home(userID: userID,))
      );
    } else {
      pr.hide();
      showDialog<AlertDialog>(
        context: context,
        builder: (BuildContext context) =>
          AlertDialog(content: const Text('Login Failed'))
      );
    }
  }
}
