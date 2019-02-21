import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

// Pages
import './scanner.dart';
import './qrgenerator.dart';
import './events.dart';
import './settings.dart';
import './account.dart';
import './codes.dart';

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
    Codes(userID: 'ders'),
  ];
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
                case 'account': Navigator.push(
                    context, MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => Account()));
                  break;
                case 'settings': Navigator.push(
                    context, MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => Settings()));
                  break;
                case 'help' : _launchHelp();
              }
            },
            offset: Offset(0, 8.0),
            itemBuilder: (BuildContext context) =>
                <ListTile>[
                  ListTile(
                    title: Text('Account'),
                    leading: Icon(Icons.account_box),
                    contentPadding: EdgeInsets.all(0.0),
                    ),
                  ListTile(
                    title: Text('Settings'),
                    leading: Icon(Icons.settings),
                    contentPadding: EdgeInsets.all(0.0),
                  ),
                  ListTile(
                    title: Text('Help'),
                    leading: Icon(Icons.help),
                    contentPadding: EdgeInsets.all(0.0),
                  ),
                ]
              .map((ListTile x) =>
                    PopupMenuItem<Text>(
                      value: x.title,
                      child: x,
                      ),
                    ).toList(),
          ),
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

  Future<void> _launchHelp() async {
    final String url = 'https://github.com/DarthEvandar/Gatekeeper/issues';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}