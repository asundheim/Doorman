import 'package:flutter/material.dart';
import '../services/api_service.dart' as api;

class Events extends StatefulWidget {
  @override
  _EventsState createState() => _EventsState();
}

List<String> events = List();

class _EventsState extends State<Events> {

  @override
  void initState() {
    _loadEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Material(
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: () => setState(() {}),
                child: addNew(),
              ),
              events == null || events.length == 0 ?
              CircularProgressIndicator()
              : Expanded(
              child: ListView.builder(
                  itemCount: (events == null ? 0 : events.length),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    const Padding(padding: EdgeInsets.all(16.0));
                    return InkWell(
                        onTap: () => setState(() {}),
                        child: ListTile(
                          title: Text(events[index]),
                        )
                    );
                  }
              ),
              )
            ],
          ),
        )
    );
  }

  Widget addNew() =>
      ListTile(
        title: const Text('Create New Event'),
        subtitle: const Text('Tap to create a new event'),
        onTap: () {
          api.createEvent('ders');
          _loadEvents();
        },
      );

  Widget getEvents() =>
      ListTile(
        title: const Text('Get Events'),
        subtitle: const Text('Tap to dump events to console'),
        onTap: () => api.getEvents('ders'),
      );

  void _loadEvents() async {
    events = await api.getEvents('ders');
    setState(() {});
  }
}
