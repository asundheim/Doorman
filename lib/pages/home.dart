import 'package:flutter/material.dart';
import './scanner.dart';
import './qrgenerator.dart';
import './auth.dart';
import './events.dart';
import './settings.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key:key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex =  1;
  final _widgetOptions = [
    Events(),
    Scanner(),
    Auth()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gatekeeper'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: ()  => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Settings())),
          )
        ],
      ),
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.all_inclusive), title: Text('Events')),
          BottomNavigationBarItem(icon: Icon(Icons.settings_overscan), title: Text('Scan')),
          BottomNavigationBarItem(icon: Icon(Icons.grid_on), title: Text('Codes')),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.deepPurple,
        onTap: (index) => _onItemTapped(index, context),
      ),
    );
  }

  void _onItemTapped(int index, BuildContext context) {
    setState(() => _selectedIndex = index);
  }
}