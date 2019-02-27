import 'dart:math';

import 'package:flutter/material.dart';
import '../classes/event.dart';
import '../services/api_service.dart' as api;
import './event_create.dart';
import './event_edit.dart';

class Events extends StatefulWidget {
  final String userID;

  const Events({Key key, @required this.userID}): super(key: key);

  @override
  _EventsState createState() => _EventsState(userID: userID);
}



class _EventsState extends State<Events> {
  String userID;
  List<Event> events = List<Event>();

  _EventsState({@required this.userID}) {
    _loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: 'Create new Event',
          child: const Icon(Icons.add),
          onPressed: () => Navigator.push(context, MaterialPageRoute<EventCreate>(builder: (BuildContext context) => EventCreate(userID: userID)))),
        body: Material(
          child: events == null || events.isEmpty ?
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    CircularProgressIndicator(),
                    Padding(
                      padding: EdgeInsets.all(24.0),
                    ),
                    Text('Loading')
                  ],
                ),
              )
              : ListView.builder(
                  itemCount: events == null ? 0 : events.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    const Padding(padding: EdgeInsets.all(16.0));
                    return InkWell(
                        onTap: () => setState(() {}),
                        child: ListTile(
                          title: Text(events[index].name),
                          subtitle: Text(events[index].description),
                          trailing: IconButton(
                              icon: const Icon(Icons.tune),
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute<EventEdit>(builder: (BuildContext context) => EventEdit(event: events[index]))),
                          ),
                        )
                    );
                  }
              ),
        )
    );
  }

  void _loadEvents() async {
    events = await api.getEvents(userID);
    setState(() {});
  }
}
