import 'package:flutter/material.dart';
import '../classes/event.dart';
import '../services/api_service.dart' as api;
import '../widgets/datetimepicker.dart';

class EventEdit extends StatefulWidget {
  final Event event;

  const EventEdit({Key key, @required this.event}): super(key: key);

  @override
  _EventEditState createState() => _EventEditState(event: event);
}

class _EventEditState extends State<EventEdit> {
  Event event;
  DateTime _date;
  TimeOfDay _time;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _EventEditState({@required this.event}) {
    _date = DateTime.fromMillisecondsSinceEpoch(event.dateTime);
    _time = TimeOfDay(hour: _date.hour, minute: _date.minute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Edit'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _saveEvent(context),
        tooltip: 'Save',
        child: const Icon(Icons.save),
      ),
      body: DropdownButtonHideUnderline(
        child: SafeArea(
          top: false,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                TextField(
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.event_note),
                      labelText: 'Name'
                  ),
                  controller: TextEditingController(text: event.name),
                  autocorrect: true,
                  onChanged: (String value) {
                    event.name = value;
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.description),
                    labelText: 'Description',
                  ),
                  controller: TextEditingController(text: event.description),
                  autocorrect: true,
                  onChanged: (String value) {
                    event.description = value;
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.location_on),
                    labelText: 'Address',
                  ),
                  controller: TextEditingController(text: event.location),
                  maxLines: 1,
                  autocorrect: true,
                  onChanged: (String value) {
                    event.location = value;
                  },
                ),
                DateTimePicker(
                  labelText: 'Time',
                  selectedDate: _date,
                  selectedTime: _time,
                  selectDate: (DateTime date) {
                    setState(() {
                      _date = date;
                      event.dateTime = DateTime(date.year, date.month, date.day, _time.hour, _time.minute).millisecondsSinceEpoch;
                    });
                  },
                  selectTime: (TimeOfDay time) {
                    setState(() {
                      _time = time;
                      event.dateTime = DateTime(_date.year, _date.month, _date.day, time.hour, time.minute).millisecondsSinceEpoch;
                    });
                  },
                ),
              ],
            )
          ),
        ),
      )
    );
  }

  final SnackBar _loadingSnackBar = const SnackBar(backgroundColor: Colors.white70, content: Text('Loading', style: TextStyle(color: Colors.black)));

  void _saveEvent(BuildContext context) async {
    _scaffoldKey.currentState.showSnackBar(_loadingSnackBar);
    await api.editEvent(event);
    _scaffoldKey.currentState.hideCurrentSnackBar();
    Navigator.pop(context);
  }
}


