import 'dart:convert';

class QRCode {
  String eventID;
  String userID;
  String rawData;

  /// Creates a new QRCode from a base64 string [qrData]
  QRCode(this.rawData) {
    final Map<String, String> map = _parseData(rawData);
    userID = map['userID'];
    eventID = map['eventID'];
  }

  /// Converts base-64 encoded [qrData] into an object with useful properties
  Map<String, String> _parseData(String qrData) {
    final List<String> raw = utf8.decode(base64Decode(qrData)).split('-');
    return <String, String> {
      'userID': raw[3],
      'eventID': raw[0]
    };
  }
}