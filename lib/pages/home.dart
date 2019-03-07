import 'package:flutter/material.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import './codes.dart';
import './events.dart';
import './scanchooser.dart';
import './settings.dart';

class Home extends StatefulWidget {
  final String userID;

  const Home({Key key, @required this.userID}) : super(key: key);

  @override
  _HomeState createState() => _HomeState(userID: userID);
}

class _HomeState extends State<Home> {
  int _selectedIndex = 1;
  String userID = 'ders';
  List<Widget> _widgetOptions;

  _HomeState({@required this.userID}) {
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
                case 'settings':
                  Navigator.push(
                      context,
                      MaterialPageRoute<Settings>(
                          builder: (BuildContext context) => Settings(userID: userID)));
                  break;
                case 'help':
                  _launchHelp();
              }
            },
            offset: const Offset(0, 8.0),
            itemBuilder: (BuildContext context) => <ListTile>[
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
      bottomNavigationBar: BubbleBottomBar(
        opacity: .2,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        elevation: 8,
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
            backgroundColor: Colors.deepPurple[300],
            icon: const Icon(Icons.event, color: Colors.black),
            activeIcon: const Icon(Icons.event, color: Colors.deepPurple),
            title: const Text('Events')),
          BubbleBottomBarItem(
            backgroundColor: Colors.deepPurple[300],
            icon: const Icon(Icons.center_focus_weak, color: Colors.black),
            activeIcon: const Icon(Icons.center_focus_weak, color: Colors.deepPurple),
            title: const Text('Scan')),
          BubbleBottomBarItem(
            backgroundColor: Colors.deepPurple[300],
            icon: const Icon(Icons.nfc, color: Colors.black),
            activeIcon: const Icon(Icons.nfc, color: Colors.deepPurple),
            title: const Text('Codes')),
        ],
        currentIndex: _selectedIndex,
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
