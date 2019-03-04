import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../classes/event.dart';
import '../services/api_service.dart' as api;
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
                itemCount: events?.length ?? 0,
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

  Future<void> _addCode() async {
    final File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    _scaffoldKey.currentState.showSnackBar(_loadingSnackBar);

    final FirebaseVisionImage visionImage =
    FirebaseVisionImage.fromFile(imageFile);
    final BarcodeDetector detector = FirebaseVision.instance.barcodeDetector();

    final dynamic results = await detector.detectInImage(visionImage) ?? <dynamic>[];
    if (results is List<Barcode> && results[0] is Barcode) {
      final Barcode res = results[0];
      print(res.displayValue);
      await api.registerCode(userID, res.displayValue);
    }
    await _getEventIDs();
    _scaffoldKey.currentState.hideCurrentSnackBar();
  }

  final SnackBar _loadingSnackBar = const SnackBar(backgroundColor: Colors.white70, content: Text('Loading', style: TextStyle(color: Colors.black)));

  Future<void> _getEventIDs() async {
    events = await api.getEventsForCodes(userID);
    setState(() {});
  }
}
