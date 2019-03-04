import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(60.0),
              child: Text('Gatekeeper', style: Theme.of(context).textTheme.display1),
            ),
            const CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
