import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../classes/qrcode.dart';
import '../services/api_service.dart' as api;


class CodeList extends StatefulWidget {
  final String eventID;
  final String userID;

  const CodeList({Key key, @required this.userID, @required this.eventID}) : super(key: key);

  @override
  _CodeListState createState() => _CodeListState(userID: userID, eventID: eventID);
}

List<QRCode> codes;

class _CodeListState extends State<CodeList> {
  final String eventID;
  final String userID;

  _CodeListState({@required this.userID, @required this.eventID}) : super();

  @override
  void initState() {
    _getCodes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Codes'),
      ),
      body: ListView.builder(
        itemCount: codes?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: QrImage(
                    data: codes[index].rawData,
                    version: 8,
                    onError: (dynamic ex) {
                      print('[QR] ERROR - $ex');
                      setState(() {});
                    }
                ),
              ),
              Text(
                  'Good for ' + codes[index].bulk.toString() + (codes[index].bulk > 1 ? ' people' : ' person'),
                  style: Theme.of(context).textTheme.subtitle
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _deleteCode(codes[index]),
              )
            ],
          );
        }
      ),
    );
  }

  void _getCodes() async {
    codes = await api.getCodes(userID, eventID);
    setState(() {});
  }

  void _deleteCode(QRCode code) async {
    showDialog<AlertDialog>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) =>
            AlertDialog(
              content: const Text('Are you sure you want to delete this code?'),
              actions: <Widget>[
                FlatButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                FlatButton(
                  child: const Text('Delete'),
                  onPressed: () => _delete(code),
                )
              ],
            )
    );
  }

  void _delete(QRCode code) async {
    await api.deleteCode(userID, code);
    codes = await api.getCodes(userID, eventID);
    setState(() {});
  }
}
