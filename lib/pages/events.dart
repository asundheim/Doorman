import 'package:flutter/material.dart';
import '../classes/event.dart';
import '../services/api_service.dart' as api;
import '../widgets/listloading.dart';
import './event_create.dart';
import './event_edit.dart';
import './event_invite.dart';

class Events extends StatefulWidget {
  final String userID;

  const Events({Key key, @required this.userID}): super(key: key);

  @override
  _EventsState createState() => _EventsState(userID: userID);
}

class _EventsState extends State<Events> {
  String userID;

  _EventsState({@required this.userID}): super();

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
          return ListLoading();
        }
      },
    );
  }

  Widget eventList(List<Event> events) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: 'Create new Event',
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(context, MaterialPageRoute<EventCreate>(builder: (BuildContext context) => EventCreate(userID: userID)))
      ),
      body: Material(
        child: ListView.builder(
          itemCount: events.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            const Padding(padding: EdgeInsets.all(16.0));
            return InkWell(
              onTap: () => setState(() {}),
              child: ListTile(
                title: Text(events[index].name),
                subtitle: Text(events[index].description),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute<EventInvite>(builder: (BuildContext context) => EventInvite(userID: userID, eventID: events[index].eventID))
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.tune),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute<EventEdit>(builder: (BuildContext context) => EventEdit(event: events[index]))),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteEvent(events[index]),
                    )
                  ],
                ),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute<EventInvite>(builder: (BuildContext context) => EventInvite(userID: userID, eventID: events[index].eventID))
                ),
              )
            );
          }
          ),
      )
    );
  }

  Widget noEvents() {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          tooltip: 'Create new Event',
          child: const Icon(Icons.add),
          onPressed: () => Navigator.push(context, MaterialPageRoute<EventCreate>(builder: (BuildContext context) => EventCreate(userID: userID)))
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'No events found. Create a new one with the button below',
              style: Theme.of(context).textTheme.subtitle,
            )
          ],
        ),
      ),
    );
  }

  void _deleteEvent(Event event) async {
    showDialog<AlertDialog>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) =>
            AlertDialog(
              content: const Text('Are you sure you want to delete this event?'),
              actions: <Widget>[
                FlatButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                FlatButton(
                  child: const Text('Delete'),
                  onPressed: () => _delete(event),
                )
              ],
            )
    );
  }

  void _delete(Event event) async {
    await api.deleteEvent(event.userID, event.eventID);
    Navigator.of(context).pop();
    setState(() {return;});
  }
}
