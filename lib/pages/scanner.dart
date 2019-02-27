import 'package:flutter/material.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import '../services/api_service.dart' as api;

enum ScanState { valid, invalid, loading }

class Scanner extends StatefulWidget {
  final String userID;
  final String eventID;

  const Scanner({Key key, @required this.userID, @required this.eventID}): super(key: key);

  @override
  _ScannerState createState() => _ScannerState(userID: userID, eventID: eventID);
}

class _ScannerState extends State<Scanner> {
  String userID;
  String eventID;
  ScanState scanState = ScanState.loading;

  _ScannerState({@required this.userID, @required this.eventID}): super();


  @override
  void initState() {
    scan(eventID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch(scanState) {
      case ScanState.loading:
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey,
          ),
          backgroundColor: Colors.grey,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                CircularProgressIndicator(),
              ],
            ),
          ),
        );
      case ScanState.valid:
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green,
          ),
          backgroundColor: Colors.green,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(Icons.check_circle, size: 48.0),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                ),
                RaisedButton(
                  color: Colors.greenAccent,
                  child: const Text('Scan again'),
                  onPressed: () {
                    setState(() => scanState = ScanState.loading);
                    scan(eventID);
                  },
                )
              ],
            ),
          ),
        );
      case ScanState.invalid:
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
          ),
          backgroundColor: Colors.red,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(Icons.not_interested, size: 48.0),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                ),
                RaisedButton(
                  color: Colors.redAccent,
                  child: const Text('Scan again'),
                  onPressed: () {
                    setState(() => scanState = ScanState.loading);
                    scan(eventID);
                  },
                )
              ],
            ),
          ),
        );
    }
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text('Error'),
          ],
        ),
      ),
    );
  }

  Future<void> scan(String eventID) async {
    String barcode = await QRCodeReader().scan();
    barcode ??= 'a-a-a-a-a';
    if (await api.verifyCode(userID, eventID, barcode)) {
      scanState = ScanState.valid;
    } else {
      scanState = ScanState.invalid;
    }
    setState(() {});
  }
}
