import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart';

Client client = Client();
const String baseURL = 'https://gatekeeper.sundheim.online';

// Create new event
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

// Get a users events
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

Future<dynamic> verifyCode(String userID, String eventID, String qrData) {
  return client.post('$baseURL/user/$userID/party/$eventID/verify', body: { 'data': qrData})
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

// Returns a Base64 String to be encoded into a QR code
Future<dynamic> generateCode(String userID, String eventID) {
  return client.post('$baseURL/user/$userID/party/$eventID/generate')
      .then((Response response) {
        Map<String, String> map = json.decode(response.body);
        print(map['qrCode']);
      })
      .catchError((Object error) {
        print('error');
        print(error.toString());
      });
}

Future<dynamic> getCode(String userID) {
  return client.get('$baseURL/user/$userID/codes')
      .then((Response response) {
    Map<String, dynamic> map = json.decode(response.body);
    print(map['code']);
  })
      .catchError((Object error) {
    print(error.toString());
  });
}