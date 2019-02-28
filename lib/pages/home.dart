import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

// Pages
import './account.dart';
import './codes.dart';
import './events.dart';
import './scanchooser.dart';
import './settings.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 1;
  String userID = 'ders';
  List<Widget> _widgetOptions;

  _HomeState() {
    _widgetOptions = <Widget>[
      Events(userID: userID),
      ScanChooser(userID: userID),
      Codes(userID: userID),
    ];
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gatekeeper'),
        actions: <Widget>[
          PopupMenuButton<Text>(
            icon: const Icon(Icons.more_vert),
            onSelected: (Text menuItem) {
              switch (menuItem.data.toLowerCase()) {
                case 'account':
                  Navigator.push<dynamic>(
                      context,
                      MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) => Account()));
                  break;
                case 'settings':
                  Navigator.push<dynamic>(
                      context,
                      MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) => Settings()));
                  break;
                case 'help':
                  _launchHelp();
              }
            },
            offset: const Offset(0, 8.0),
            itemBuilder: (BuildContext context) => <ListTile>[
                  const ListTile(
                    title: Text('Account'),
                    leading: Icon(Icons.account_box),
                    contentPadding: EdgeInsets.all(0.0),
                  ),
                  const ListTile(
                    title: Text('Settings'),
                    leading: Icon(Icons.settings),
                    contentPadding: EdgeInsets.all(0.0),
                  ),
                  const ListTile(
                    title: Text('Help'),
                    leading: Icon(Icons.help),
                    contentPadding: EdgeInsets.all(0.0),
                  ),
                ].map((ListTile x) => PopupMenuItem<Text>(value: x.title, child: x,)).toList(),
          ),
        ],
      ),
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.all_inclusive), title: Text('Events')),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_overscan), title: Text('Scan')),
          BottomNavigationBarItem(
              icon: Icon(Icons.grid_on), title: Text('Codes')),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.deepPurple,
        onTap: (int index) => _onItemTapped(index, context),
      ),
    );
  }

  void _onItemTapped(int index, BuildContext context) {
    setState(() => _selectedIndex = index);
  }

  Future<void> _launchHelp() async {
    const String url = 'https://github.com/DarthEvandar/Gatekeeper/issues';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
