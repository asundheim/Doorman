import 'dart:convert';

class QRCode {
  String eventID;
  String userID;
  String rawData;
  int bulk;

  /// Creates a new QRCode from a base64 string [qrData]
  QRCode(this.rawData) {
    final Map<String, dynamic> map = _parseData(rawData);
    userID = map['userID'];
    eventID = map['eventID'];
    bulk = int.parse(map['bulk']);
  }

  /// Converts base-64 encoded [qrData] into an object with useful properties
  Map<String, String> _parseData(String qrData) {
    final List<String> raw = utf8.decode(base64Decode(qrData)).split('-');
    return <String, String> {
      'userID': raw[3],
      'eventID': raw[0],
      'bulk': raw[4],
    };
  }
}