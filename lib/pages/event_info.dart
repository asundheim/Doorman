import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../classes/event.dart';

class EventInfo extends StatefulWidget {
  final Event event;

  const EventInfo({Key key, @required this.event}): super(key: key);

  @override
  _EventInfoState createState() => _EventInfoState(event: event);
}

class _EventInfoState extends State<EventInfo> {
  Event event;

  _EventInfoState({@required this.event}): super();

  @override
  Widget build(BuildContext context) {
    final DateTime time = DateTime.fromMillisecondsSinceEpoch(event.dateTime);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Info'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(
                    icon: Icon(Icons.event_note),
                    labelText: 'Name'
                ),
                controller: TextEditingController(text: event.name),
                enabled: false,
              ),
              TextField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.description),
                  labelText: 'Description',
                ),
                controller: TextEditingController(text: event.description),
                enabled: false,
              ),
              TextField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.location_on),
                  labelText: 'Address',
                ),
                controller: TextEditingController(text: event.location),
                enabled: false,
              ),
              TextField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.access_time),
                  labelText: 'Time',
                ),
                controller: TextEditingController(
                    text: DateFormat.yMMMd().format(time) + ' at '+ TimeOfDay(hour: time.hour, minute: time.minute).format(context)
                ),
                enabled: false,
              )
            ],
          )
        ),
      ),
    );
  }
}
