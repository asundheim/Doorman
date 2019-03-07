import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ListLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SpinKitWave(color: Colors.deepPurple, type: SpinKitWaveType.start),
            const Padding(
              padding: EdgeInsets.all(24.0),
            ),
            const Text('Loading')
          ],
        ),
      ),
    );
  }
}
