import 'dart:collection';
import 'dart:math';

import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:noteapp/services/firestore_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:noteapp/widgets/appointment_editor.dart';
import 'package:intl/intl.dart';
import 'package:noteapp/ui/todo/empty_content.dart';


class LoadDataFromFireStore extends StatefulWidget {
  @override
  LoadDataFromFireStoreState createState() => LoadDataFromFireStoreState();
}

class LoadDataFromFireStoreState extends State<LoadDataFromFireStore> {
  List<DocumentSnapshot> querySnapshot;
  dynamic data;
  List<Color> _colorCollection;

  @override
  void initState() {
    _initializeEventColor();
    final firestoreDatabase = Provider.of<FirestoreDatabase>(context, listen: false);
    firestoreDatabase.allEvents().then((results) {
      setState(() {
        if (results != null) {
          querySnapshot = results;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showCalendar(),
    );
  }

  _showCalendar() {
    if (querySnapshot != null) {
      List<Meeting> collection;
      for (DocumentSnapshot snapshotdata in querySnapshot) {
        Map<dynamic, dynamic> values = snapshotdata.data;
        if (values != null) {
          data = values;
          collection ??= <Meeting>[];
          final Random random = new Random();
          collection.add(Meeting(
              eventName: data['eventName'],
              isAllDay: false,
              from: data['from'].toDate(),
              to: data['to'].toDate(),
              background: _colorCollection[random.nextInt(9)]));
        }
        else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }

      return SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SfCalendar(
                  view: CalendarView.day,
                  initialDisplayDate: DateTime.now(),
                  dataSource: _getCalendarDataSource(collection),
                  monthViewSettings: MonthViewSettings(showAgenda: true),
                ),
              ),
            ],
          ));
    }
  }

  void _initializeEventColor() {
    this._colorCollection = new List<Color>();
    _colorCollection.add(const Color(0xFF0F8644));
    _colorCollection.add(const Color(0xFF8B1FA9));
    _colorCollection.add(const Color(0xFFD20100));
    _colorCollection.add(const Color(0xFFFC571D));
    _colorCollection.add(const Color(0xFF36B37B));
    _colorCollection.add(const Color(0xFF01A1EF));
    _colorCollection.add(const Color(0xFF3D4FB5));
    _colorCollection.add(const Color(0xFFE47C73));
    _colorCollection.add(const Color(0xFF636363));
    _colorCollection.add(const Color(0xFF0A8043));
  }
}

MeetingDataSource _getCalendarDataSource([List<Meeting> collection]) {
  List<Meeting> meetings = collection ?? <Meeting>[];
  return MeetingDataSource(meetings);
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }
}

class Meeting {
  Meeting({this.eventName, this.from, this.to, this.background, this.isAllDay});

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
