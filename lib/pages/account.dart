import 'package:flutter/material.dart';

import 'package:gatekeeper/services/auth_service.dart' as authService;

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text('Sign In'),
              onPressed: () => authService.handleSignIn(),
            ),
            RaisedButton(
              child: Text('Sign Out'),
              onPressed: () => authService.handleSignOut(),
            )
            //Text(currentUser),
          ],
        ),
      ),
    );
  }
}
