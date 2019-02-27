import 'package:flutter/material.dart';
import '../services/api_service.dart' as api;
import './codelist.dart';

class Codes extends StatefulWidget {
  final String userID;

  const Codes({Key key, @required this.userID}): super(key: key);

  @override
  _CodesState createState() => _CodesState(userID: userID);
}

class _CodesState extends State<Codes> {
  final String userID;
  List<String> eventIDs;

  _CodesState({@required this.userID}) {
    _getEventIDs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Material(
          child: Column(
            children: <Widget>[
              eventIDs != null && eventIDs.isEmpty ?
              ListView(
                shrinkWrap: true,
                children: <Widget>[
                  InkWell(
                    onTap: () => setState(() {}),
                    child: ListTile(
                    title: const Text('Tap to test QR Codes page'),
                    onTap: () => Navigator.push<dynamic>(
                      context, MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => const CodeList(userID:'ders', eventID:'agrmny'))),
                    ),
                  ),
                ],
              )
              : Expanded(
                child: ListView.builder(
                    itemCount: eventIDs == null ? 0 : eventIDs.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) =>
                      InkWell(
                        child: ListTile(
                          title: Text(eventIDs[index]),
                          onTap: () => Navigator.push<dynamic>(
                            context, MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) => CodeList(userID: userID, eventID: eventIDs[index]))
                          ),
                        )
                      )
                ),
              ),
            ],
          ),
        )
    );
  }

  void _getEventIDs() async {
    eventIDs = await api.getEventsForCodes(userID);
    setState(() {});
  }
}
