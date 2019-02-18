import 'package:flutter/material.dart';
import '../services/api_service.dart' as api;

class Events extends StatefulWidget {
  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events')
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          addNew(),
          getEvents()
        ],
      )
    );
  }

  Widget addNew() =>
    ListTile(
      title: const Text('Create New Event'),
      subtitle: const Text('Tap to create a new event'),
      onTap: () => api.createEvent('ders'),
    );

  Widget getEvents() =>
      ListTile(
        title: const Text('Get Events'),
        subtitle: const Text('Tap to dump events to console'),
        onTap: () => api.getEvents('ders'),
      );
}
