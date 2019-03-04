import 'package:flutter/material.dart';
import './home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Icon _userValid = Icon(Icons.clear, color: Colors.red[300]);
  Icon _passwordValid = Icon(Icons.clear, color: Colors.red[300]);

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
                  decoration: InputDecoration(
                    icon: const Icon(Icons.person, color: Colors.grey),
                    suffixIcon: _userValid,
                    labelText: 'Username',
                    labelStyle: TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: _userValid.color)
                    ),
                  ),
                  onChanged: (String value) =>
                      setState(() =>
                        _userValid = value.isEmpty ?
                          Icon(Icons.clear, color: Colors.red[300]) :
                          Icon(Icons.check, color: Colors.green[300])
                      )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
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

  }

  void _login() {
    Navigator.push<dynamic>(
        context, MaterialPageRoute<Home>(
        builder: (BuildContext context) => const Home(userID: 'ders'))
    );
  }
}
