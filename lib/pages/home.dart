import 'package:flutter/material.dart';
import './scanner.dart';
import './qrgenerator.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                  child: Text('QR Scanner'),
                  color: Colors.red,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Scanner()));
                  }
              ),
              RaisedButton(
                child: Text('QR Generator'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => QRGenerator()));
                },
              )
            ],
          )
      ),
    );
  }
}