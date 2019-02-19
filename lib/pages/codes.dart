import 'package:flutter/material.dart';
import './codelist.dart';
import '../services/api_service.dart' as api;

class Codes extends StatefulWidget {
  final String userID;

  Codes({Key key, @required this.userID}): super(key: key);

  @override
  _CodesState createState() => _CodesState(userID: this.userID);
}

List<String> eventIDs;

class _CodesState extends State<Codes> {
  final String userID;

  _CodesState({Key key, @required this.userID}): super();

  @override
  void initState() {
    _getEventIDs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Material(
          child: Column(
            children: <Widget>[
              eventIDs != null && eventIDs.length == 0 ?
              ListView(
                shrinkWrap: true,
                children: <Widget>[
                  InkWell(
                    onTap: () => setState(() {}),
                    child: ListTile(
                    title: Text('Tap to test QR Codes page'),
                    onTap: () => Navigator.push(
                      context, MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => CodeList(userID:'ders', eventID:'grlz'))),
                    ),
                  ),
                ],
              ) :
              Expanded(
                child: ListView.builder(
                    itemCount: eventIDs == null ? 0 : eventIDs.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) =>
                      InkWell(
                        child: ListTile(
                          title: Text(eventIDs[index]),
                          onTap: () => Navigator.push(
                            context, MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) => CodeList(userID: this.userID, eventID: eventIDs[index]))
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
    eventIDs = await api.getEventsForCodes(this.userID);
    setState(() {});
  }
}
