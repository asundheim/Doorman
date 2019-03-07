import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gatekeeper/widgets/progress_dialog.dart';
import 'package:image_picker/image_picker.dart';
import '../classes/event.dart';
import '../services/api_service.dart' as api;
import '../widgets/listloading.dart';
import './codelist.dart';
import './event_info.dart';

class Codes extends StatefulWidget {
  final String userID;

  const Codes({Key key, @required this.userID}): super(key: key);

  @override
  _CodesState createState() => _CodesState(userID: userID);
}

class _CodesState extends State<Codes> {
  final String userID;
  List<Event> events;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _CodesState({@required this.userID}) {
    _getEventIDs();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Event>>(
      future: api.getEventsForCodes(userID),
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
          tooltip: 'Import code',
          child: const Icon(Icons.add),
          onPressed: _addCode,
        ),
        key: _scaffoldKey,
        body: Material(
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: events.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) =>
                    InkWell(
                      child: ListTile(
                        title: Text(events[index].name),
                        subtitle: Text(events[index].description),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.code),
                              onPressed: () => Navigator.push(
                                context, MaterialPageRoute<CodeList>(
                                  builder: (BuildContext context) => CodeList(userID: userID, eventID: events[index].eventID)),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.info_outline),
                              onPressed: () => Navigator.push(
                                  context, MaterialPageRoute<EventInfo>(
                                  builder: (BuildContext context) => EventInfo(event: events[index]))
                              ),
                            ),
                          ],
                        ),
                        onTap: () => Navigator.push(
                            context, MaterialPageRoute<CodeList>(
                            builder: (BuildContext context) => CodeList(userID: userID, eventID: events[index].eventID))
                        ),
                      )
                    )
                ),
              ),
            ],
          ),
        )
    );
  }

  Widget noEvents() {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: 'Import code',
        child: const Icon(Icons.add),
        onPressed: _addCode,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You haven\'t imported any codes yet.',
              style: Theme.of(context).textTheme.subtitle
            )
          ],
        ),
      ),
    );
  }

  Future<void> _addCode() async {
    final File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    final ProgressDialog pr = ProgressDialog(
        context,
        loadingIndicator: SpinKitWave(color: Colors.deepPurple, type: SpinKitWaveType.start),
        progressDialogType: ProgressDialogType.Material,
        loadingIndicatorWidth: 62.5
    );
    pr.setMessage('Importing...');
    pr.show();
    try {
      final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(imageFile);
      final BarcodeDetector detector = FirebaseVision.instance.barcodeDetector(
        const BarcodeDetectorOptions(barcodeFormats: BarcodeFormat.qrCode)
      );

      final List<Barcode> results = await detector.detectInImage(visionImage);
      if (results is List<Barcode> && results.isNotEmpty) {
        final Barcode res = results[0];
        await api.registerCode(userID, res.displayValue);
      } else {
        throw 'No Code found in image';
      }
      setState(() {});
      pr.hide();
    } catch(Exception) {
      print(Exception.toString());
      pr.hide();
    }
  }

  final SnackBar _loadingSnackBar = const SnackBar(backgroundColor: Colors.white70, content: Text('Loading', style: TextStyle(color: Colors.black)));

  Future<void> _getEventIDs() async {
    events = await api.getEventsForCodes(userID);
    setState(() {});
  }
}
