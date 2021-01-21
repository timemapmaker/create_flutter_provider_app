import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class EventModel {
  final String id;
  final String eventName;
  final DateTime from;
  final DateTime to;
  final Color background;
  final bool isAllDay;
  final String description;


  EventModel(
      {@required this.id,
        @required this.from,
        @required this.to,
        this.background = Colors.green,
        this.isAllDay = false,
        this.eventName = '',
        this.description = '',
      });

  factory EventModel.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }

    String eventName = data['eventName'];
    DateTime from = data['from'].toDate();
    DateTime to = data['to'].toDate();
    Color background = data['background'];
    bool isAllDay = data['isAllDay'];
    String description = data['description'];

    return EventModel(
        id: documentId, eventName: eventName, from: from, to: to, background: background, isAllDay: isAllDay, description: description);
  }

  Map<String, dynamic> toMap() {
    return {
      'eventName': eventName,
      'from': from,
      'to': to,
      'background': background,
      'isAllDay': isAllDay,
      'description': description,
    };
  }
}
