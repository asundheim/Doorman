import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gatekeeper/widgets/progress_dialog.dart';
import '../classes/event.dart';
import '../services/api_service.dart' as api;
import '../widgets/datetimepicker.dart';

class EventCreate extends StatefulWidget {
  final String userID;

  const EventCreate({Key key, @required this.userID}): super(key: key);

  @override
  _EventCreateState createState() => _EventCreateState(userID: userID);
}

class _EventCreateState extends State<EventCreate> {
  Event event;
  DateTime _date = DateTime.now();
  TimeOfDay _time =  const TimeOfDay(hour: 22, minute: 0);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _EventCreateState({@required String userID}) {
    event = Event(userID: userID, eventID: _newEventID());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Create'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createEvent(context),
        tooltip: 'Create',
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
                      labelText: 'Name',
                  ),
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

  String _newEventID() {
    final Random rand = Random();
    const String alphaString = 'abcdefghijklmnopqrstuvwxyz';
    String partyID = '';
    for (int i = 0; i < 6; i++) {
      partyID += alphaString[rand.nextInt(26)];
    }
    return partyID;
  }

  void _createEvent(BuildContext context) async {
    final ProgressDialog pr = ProgressDialog(
        context,
        loadingIndicator: SpinKitWave(color: Colors.deepPurple, type: SpinKitWaveType.start),
        progressDialogType: ProgressDialogType.Material,
        loadingIndicatorWidth: 62.5
    );
    pr.setMessage('Creating...');
    pr.show();
    await api.createEvent(event);
    pr.hide();
    Navigator.pop(context);
  }
}