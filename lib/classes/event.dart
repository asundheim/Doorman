import 'package:flutter/material.dart';

class Event {
  String userID;
  String eventID;
  String name;
  String description;
  String location;
  String dateTime;

  Event({@required this.userID, @required this.eventID, this.name = '', this.description = '', this.location = '', this.dateTime = ''});
}