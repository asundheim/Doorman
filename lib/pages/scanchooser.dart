import 'package:flutter/material.dart';
import '../classes/event.dart';
import '../services/api_service.dart' as api;
import './scanner.dart';


class ScanChooser extends StatefulWidget {
  final String userID;

  const ScanChooser({Key key, @required this.userID}): super(key: key);

  @override
  _ScanState createState() => _ScanState(userID: userID);
}

class _ScanState extends State<ScanChooser> {
  String userID;
  String barcode = '';

  _ScanState({@required this.userID}): super();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Event>>(
      future: api.getEvents(userID),
      builder: (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.isNotEmpty) {
            return eventList(snapshot.data);
          } else {
            return noEvents();
          }
        } else {
          return loading();
        }
      },
    );
  }

  Widget eventList(List<Event> events) {
    return Scaffold(
      body: Material(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: events.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () => setState(() {}),
                    child: ListTile(
                      title: Text(events[index].name ?? 'Default Name'),
                      subtitle: Text(events[index].eventID),
                      onTap: () => Navigator.push<dynamic>(
                          context,
                          MaterialPageRoute<dynamic>(
                              builder: (BuildContext context) => Scanner(userID: userID, eventID: events[index].eventID))),
                    ),
                  );
                }
              ),
            )
          ],
        ),
      )
    );
  }

  Widget noEvents() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const <Widget>[
            Text('No events found. Create a new one in the events tab to the left')
          ],
        ),
      ),
    );
  }

  Widget loading() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const <Widget>[
            CircularProgressIndicator(),
            Padding(
              padding: EdgeInsets.all(1.0),
            ),
            Text('Loading')
          ],
        ),
      ),
    );
  }
}