import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../classes/qrcode.dart';
import '../services/api_service.dart' as api;

class EventInvite extends StatefulWidget {
  final String userID;
  final String eventID;

  const EventInvite({Key key, @required this.userID, @required this.eventID}): super(key: key);

  @override
  _EventInviteState createState() => _EventInviteState(userID: userID, eventID: eventID);
}

class _EventInviteState extends State<EventInvite> {
  String userID;
  String eventID;
  int _batch = 1;
  GlobalKey globalKey = GlobalKey();
  QRCode qrCode;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _EventInviteState({@required this.userID, @required this.eventID}): super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Invite'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton(
                  color: Colors.white,
                  child: Text('Create a code for $_batch people'),
                  onPressed: () => _renderCode(),
                ),
                Card(
                  elevation: 3.0,
                  child: NumberPicker.integer(
                      initialValue: _batch,
                      minValue: 1,
                      maxValue: 10,
                      onChanged: (num newValue) =>
                          setState(() => _batch = newValue))
                ),
              ]
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                qrCode != null ?
                  Container(
                    child: Center(
                      child: RepaintBoundary(
                        key: globalKey,
                        child: QrImage(
                            backgroundColor: Colors.white,
                            data: qrCode.rawData,
                            version: 7,
                            size: 256.0,
                            onError: (dynamic ex) {
                              print('[QR] ERROR - $ex');
                              setState(() {});
                            }
                        ),
                      ),
                  )
                )
                : Container(),
                qrCode != null ?
                  RaisedButton(
                    color: Colors.white,
                    child: const Text('Share'),
                    onPressed: () => _captureAndSharePng(),
                ) : Container(),
              ],
            )
          ],
        ),
      ),
    );
  }

  final SnackBar _loadingSnackBar = const SnackBar(backgroundColor: Colors.white70, content: Text('Generating', style: TextStyle(color: Colors.black)));

  void _renderCode() async {
    _scaffoldKey.currentState.showSnackBar(_loadingSnackBar);
    qrCode = QRCode(await api.generateCode(userID, eventID, _batch));
    _scaffoldKey.currentState.hideCurrentSnackBar();
    setState(() {});
  }

  Future<void> _captureAndSharePng() async {
    try {
      final RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData.buffer.asUint8List();

      final Directory tempDir = await getTemporaryDirectory();
      final File file = await File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes);

      const MethodChannel channel = MethodChannel('channel:me.gatekeeper.share/share');
      channel.invokeMethod<dynamic>('shareFile', 'image.png');
    } catch(e) {
      print(e.toString());
    }
  }
}
