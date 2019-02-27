import 'dart:async';
import 'dart:convert';
import 'package:gatekeeper/classes/event.dart';
import 'package:gatekeeper/classes/qrcode.dart';
import 'package:http/http.dart';

Client client = Client();
/// URL for emulator to debug the server
// const String baseURL = 'http://10.0.2.2:8080';
const String baseURL = 'https://gatekeeper.sundheim.online';

/// Create new event given [event]
Future<bool> createEvent(Event event) {
  return client.post('$baseURL/user/${event.userID}/newevent/${event.eventID}',
        headers: jsonHeaders(),
        body: eventBody(event)
      )
      .then((Response response) {
        final Map<String, dynamic> map = json.decode(response.body);
        return map['success'] as bool;
      });
}

Future<bool> editEvent(Event event) {
  return client.post('$baseURL/user/${event.userID}/editevent/${event.eventID}',
      headers: jsonHeaders(),
      body: eventBody(event)
    )
    .then((Response response) {
      final Map<String, dynamic> map = json.decode(response.body);
      return map['success'] as bool;
    });
}

/// Get a users events given [userID]
Future<List<Event>> getEvents(String userID) {
  return client.get('$baseURL/user/$userID/events')
      .then((Response response) {
        final Map<String, dynamic> map = json.decode(response.body);
        return List<dynamic>.from(map['events']).map((dynamic event) {
          return Event(eventID: event['eventID'], userID: event['userID'], name: event['name'], description: event['description'], location: event['location'], dateTime: event['dateTime']);
        }).toList();
      });
}

/// Get number of issued keys for [userID] event [eventID]
Future<int> getIssuedKeys(String userID, String eventID) {
  return client.get('$baseURL/user/$userID/issued')
      .then((Response response) {
        final Map<String, dynamic> map = json.decode(response.body);
        print(map['issued']);
      });
}

/// Given an event owner [userID], event [eventID], and QR code [qrData]
/// check if the code is valid and scan it if it is
/// returns [bool] var [success] if completed successfully
Future<bool> verifyCode(String userID, String eventID, String qrData) {
  return client.post('$baseURL/user/$userID/party/$eventID/verify',
        headers: jsonHeaders(),
        body: json.encode(<String, String>{'code': qrData}))
      .then((Response response) {
        print(response.body);
        final Map<String, dynamic> map = json.decode(response.body);
        print(map['message']);
        print(map['success']);
        return map['success'] as bool;
      });
}

/// Returns a Base64 String to be encoded into a QR code
/// for the owner [userID] of the event [eventID] and number of codes [bulk]
Future<String> generateCode(String userID, String eventID, int bulk) {
  return client.post('$baseURL/user/$userID/event/$eventID/generate',
          headers: jsonHeaders(),
          body: json.encode(<String, dynamic>{ 'bulk': bulk })
      ).then((Response response) {
        final Map<String, dynamic> map = json.decode(response.body);
        return map['qrCode'];
      });
}

/// Gets codes a user [userID] owns for event [eventID]
Future<List<QRCode>> getCodes(String userID, String eventID) {
  return client.get('$baseURL/user/$userID/codes/$eventID/codes')
      .then((Response response) {
        final Map<String, dynamic> map = json.decode(response.body);
        return List<String>.from(map['codes']).map((String code) => QRCode(code)).toList();
      });
}


/// Adds a base64 string [qrCode] to a user [userID]
Future<bool> registerCode(String userID, String qrCode) {
  return client.post('$baseURL/user/$userID/codes/register/',
          headers: jsonHeaders(),
          body: json.encode(<String, dynamic>{'code': qrCode})
      ).then((Response response) {
        final Map<String, dynamic> map = json.decode(response.body);
        print(map['message']);
        return map['success'];
      });
}

/// Gets event IDs that a user [userID] has codes for
Future<List<String>> getEventsForCodes(String userID) {
  return client.get('$baseURL/user/$userID/codes/events')
      .then((Response response) {
        final Map<String, dynamic> map = json.decode(response.body);
        return List<String>.from(map['ids']);
      });
}

Map<String, String> jsonHeaders() => <String, String>{'Content-Type': 'application/json'};

String eventBody(Event event) {
  return json.encode(<String, dynamic>{
    'name': event.name,
    'description': event.description,
    'location': event.location,
    'dateTime': event.dateTime
  });
}