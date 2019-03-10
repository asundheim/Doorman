import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
              child: Text('Doorman', style: Theme.of(context).textTheme.display1),
            ),
            SpinKitWave(color: Colors.deepPurple, type: SpinKitWaveType.start)
          ],
        ),
      ),
    );
  }
}
