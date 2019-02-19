import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'package:gatekeeper/classes/qrcode.dart';
import 'package:http/http.dart';

Client client = Client();
const String baseURL = 'https://gatekeeper.sundheim.online';

/// Create new event given [userID]
Future<dynamic> createEvent(String userID) {
  Random rand = Random();
  const String alphaString = 'abcdefghijklmnopqrstuvwxyz';
  String partyID = '';
  for (int i = 0; i < 4; i++) {
    partyID += alphaString[rand.nextInt(26)];
  }
  return client.post('$baseURL/user/$userID/newparty/$partyID')
      .then((Response response) {
        final Map<String, dynamic> map = json.decode(response.body);
        print(map['success']);
      })
      .catchError((Object e) {
        print('Error');
        print(e.toString());
      });
}

/// Get a users events given [userID]
Future<dynamic> getEvents(String userID) {
  return client.get('$baseURL/user/$userID/parties')
      .then((Response response) {
        final Map<String, dynamic> map = json.decode(response.body);
        final List<String> list = List<String>.from(map['events']);
        print(map['events']);
        return list;
      })
      .catchError((Object error) {
        print('error');
        print(error.toString());
      });
}

/// get number of issued keys for [userID] event [eventID]
Future<dynamic> getIssuedKeys(String userID, String eventID) {
  return client.get('$baseURL/user/$userID/issued')
      .then((Response response) {
        Map<String, dynamic> map = json.decode(response.body);
        print(map['issued']);
      })
      .catchError((Object error) {
        print('error');
        print(error.toString());
      });
}

/// Given an event ownwer [userID], event [eventID], and QR code [qrData]
/// check if the code is valid and scan it if it is
/// returns [bool] var [success] if completed successfully
Future<dynamic> verifyCode(String userID, String eventID, String qrData) {
  return client.post('$baseURL/user/$userID/party/$eventID/verify', body: { 'code': qrData})
      .then((Response response) {
        Map<String, dynamic> map = json.decode(response.body);
        print(map['message']);
        print(map['success']);
      })
      .catchError((Object error) {
        print('error');
        print(error.toString());
      });
}

/// Returns a Base64 String to be encoded into a QR code
/// for the owner [userID] of the event [eventID]
Future<dynamic> generateCode(String userID, String eventID) {
  return client.post('$baseURL/user/$userID/party/$eventID/generate')
      .then((Response response) {
        Map<String, dynamic> map = json.decode(response.body);
        return map['qrcode'];
      })
      .catchError((Object error) {
        print('error');
        print(error.toString());
      });
}

/// Gets codes a user [userID] owns for event [eventID]
Future<dynamic> getCodes(String userID, String eventID) {
  return client.get('$baseURL/user/$userID/codes/$eventID')
      .then((Response response) {
        Map<String, dynamic> map = json.decode(response.body);
        return List<String>.from(map['codes']).map((String code) => QRCode(code));
      })
      .catchError((Object error) {
        print('error');
        print(error.toString());
      });
}


/// Adds a base64 string [qrCode] to a user [userID]
Future<dynamic> registerCode(String userID, String qrCode) {
  return client.post('$baseURL/user/$userID/codes/register/', body: {'code': qrCode})
      .then((Response repsonse){
        Map<String, dynamic> map = json.decode(repsonse.body);
        print(map['message']);
        return map['success'] as bool;
      })
      .catchError((Object error) {
        print('error');
        print(error.toString());
      });
}

/// Gets event IDs that a user [userID] has codes for
Future<dynamic> getEventsForCodes(String userID) {
  return client.get('$baseURL/user/$userID/codes/events')
      .then((Response response) {
        Map<String, dynamic> map = json.decode(response.body);
        return List<String>.from(map['ids']);
      })
      .catchError((Object error) {
        print('error');
        print(error.toString());
      });
}