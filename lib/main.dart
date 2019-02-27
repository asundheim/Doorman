import 'package:flutter/material.dart';
import './pages/home.dart';
void main() => runApp(Main());

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gatekeeper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home()
    );
  }
}
