import 'package:flutter/material.dart';
import 'package:gatekeeper/classes/qrcode.dart';
import 'package:gatekeeper/services/api_service.dart' as api;
import 'package:qr_flutter/qr_flutter.dart';

class CodeList extends StatefulWidget {
  final String eventID;
  final String userID;

  CodeList({Key key, @required this.userID, @required this.eventID}) : super(key: key);

  @override
  _CodeListState createState() => _CodeListState(userID: this.userID, eventID: this.eventID);
}

List<QRCode> codes;

class _CodeListState extends State<CodeList> {
  final String eventID;
  final String userID;

  _CodeListState({Key key, @required this.userID, @required this.eventID}) : super();

  @override
  void initState() {
    _getCodes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Material(
        child: Column(
          children: <Widget>[
            codes == null ? CircularProgressIndicator() : Expanded(
              child: codes.length == 0 ?
              ListView(
                shrinkWrap: true,
                children: <Widget>[
                  ListTile(
                    title: Text('No Codes found for this event'),
                    subtitle: Text('Tap to add a random code to this event'),
                    onTap: () => _generateRandomCode(),
                  )
                ],
              ): ListView.builder(
                  itemCount: codes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        child: Center(
                          child: Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: QrImage(
                                data: codes[index].rawData,
                                version: 7,
                                onError: (dynamic ex) {
                                  print('[QR] ERROR - $ex');
                                  setState(() {});
                                }
                              )
                          ),
                        )
                    );
                  }
              )
            ),
          ]
        )
      )
    );
  }

  void _getCodes() async {
    codes = await api.getCodes(this.userID, this.eventID);
    setState(() {});
  }

  void _generateRandomCode() async {
    String code = await api.generateCode(this.userID, this.eventID);
    await api.registerCode(this.userID, code);
    _getCodes();
  }
}