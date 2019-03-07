import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gatekeeper/widgets/progress_dialog.dart';
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
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  _EventEditState({@required this.event}) {
    _date = DateTime.fromMillisecondsSinceEpoch(event.dateTime);
    _time = TimeOfDay(hour: _date.hour, minute: _date.minute);
    nameController.text = event.name;
    descriptionController.text = event.description;
    addressController.text = event.location;
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
                  controller: nameController,
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
                  controller: descriptionController,
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
                  controller: addressController,
                  maxLines: 1,
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

  void _saveEvent(BuildContext context) async {
    final ProgressDialog pr = ProgressDialog(
        context,
        loadingIndicator: SpinKitWave(color: Colors.deepPurple, type: SpinKitWaveType.start),
        progressDialogType: ProgressDialogType.Material,
        loadingIndicatorWidth: 62.5
    );
    pr.setMessage('Saving...');
    pr.show();
    await api.editEvent(event);
    pr.hide();
    Navigator.pop(context);
  }
}


