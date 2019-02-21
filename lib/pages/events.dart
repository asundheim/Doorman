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
      floatingActionButton: FloatingActionButton(
        tooltip: "Create new Event",
          child: Icon(Icons.add),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => CreateNewEvent()))),
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

class CreateNewEvent extends StatefulWidget {
  @override
  _CreateNewEventState createState() => _CreateNewEventState();
}

class _CreateNewEventState extends State<CreateNewEvent> {

  String eventName;
  String eventDescription;
  String eventAddress;
  String eventDateTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create new event'),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _createEvent(eventName, eventDescription, eventAddress, eventDateTime);
            Navigator.pop(context);
          },
        tooltip: "Submit",
        child: Icon(Icons.check),
      ),
      body: Material(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
              children: <Widget>[
                // TODO add text validators to TextFormFields
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  icon: Icon(Icons.event_note),
                  labelText: 'Event Name',
                  hintText: 'Phineas\' intimate get together',
                ),
                maxLength: 30,
                autocorrect: true,
                maxLengthEnforced: true,
                onSaved: (String value) {
                  eventName = value;
                },
              ),
          TextFormField(
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              icon: Icon(Icons.description),
              labelText: 'Event Discription',
              hintText: 'Strict spiderman theme, will turn away anyone who does not conform, extended universe is fair',
            ),
            maxLines: 5,
            autocorrect: true,
            onSaved: (String value) {
              eventDescription = value;
            },
          ),
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  icon: Icon(Icons.location_on),
                  labelText: 'Address',
                  hintText: '221B Baker St',
                ),
                maxLines: 1,
                autocorrect: true,
                onSaved: (String value) {
                  eventAddress = value;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(
                  icon: Icon(Icons.calendar_today),
                  labelText: 'Time (replace with datetime picker)',
                  hintText: '12/1/1 5:00pm',
                ),
                maxLines: 1,
                onSaved: (String value) {
                  eventDateTime = value;
                },
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}

// TODO move to service and finish

Future<void> _createEvent(String name, description, address, dateTime) {
  // TODO send data to the server
}

