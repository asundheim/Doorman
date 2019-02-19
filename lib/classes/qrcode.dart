import 'dart:convert';

class QRCode {
  String eventID;
  String userID;
  String rawData;

  /// Creates a new QRCode from a base64 string [qrData]
  QRCode(String qrData) {
    this.rawData = qrData;
    Map<String, String> map = _parseData(qrData);
    this.userID = map['userID'];
    this.eventID = map['eventID'];
  }

  /// Converts base-64 encoded [qrData] into an object with useful properties
  Map<String, String> _parseData(String qrData) {
    List<String> raw = utf8.decode(base64Decode(qrData)).split('-');
    return <String, String> {
      'userID': raw[3],
      'eventID': raw[0]
    };
  }
}