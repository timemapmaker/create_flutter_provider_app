import 'dart:math';

import 'package:flutter/material.dart';
import 'package:noteapp/models/user_model.dart';
import 'package:noteapp/models/event_model.dart';
import 'package:noteapp/providers/auth_provider.dart';
import 'package:noteapp/routes.dart';
import 'package:noteapp/services/firestore_database.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noteapp/widgets/appointment_editor.dart';

CalendarController _controller;
Color headerColor, viewHeaderColor, calendarColor, defaultColor;
MeetingDataSource _events;
Meeting _selectedAppointment;
DateTime _startDate;
TimeOfDay _startTime;
DateTime _endDate;
TimeOfDay _endTime;
bool _isAllDay;
String _subject = '';
String _notes = '';
String _eventid='';

class calendarScreen extends StatelessWidget{
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final firestoreDatabase = Provider.of<FirestoreDatabase>(
        context, listen: false);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: StreamBuilder(
            stream: authProvider.user,
            builder: (context, snapshot) {
              final UserModel user = snapshot.data;
              return Text(
                  "Calendar");
            }),
        actions: <Widget>[
          SizedBox(width: 10.0),
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.setting);
              }
          ),
        ],
      ),
      bottomNavigationBar: bottomnav(),
      body: WillPopScope(
          onWillPop: () async => false,
          child: LoadDataFromFireStore()),
    );
  }
}

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
  _controller = CalendarController();
  _controller.view = CalendarView.month;
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
            eventId: data['eventId'],
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
                  view: _controller.view,
                  allowedViews: <CalendarView>
                  [
                    CalendarView.day,
                    CalendarView.week,
                    CalendarView.workWeek,
                    CalendarView.month,
                    CalendarView.schedule
                  ],
                  onTap: onCalendarTapped,
                  showDatePickerButton: true,
                  initialDisplayDate: DateTime.now(),
                  dataSource: _getCalendarDataSource(collection),
                  monthViewSettings: MonthViewSettings(showAgenda: true),
                ),
              ),
            ],
          ));
    }
  }

  void onCalendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement != CalendarElement.calendarCell &&
        calendarTapDetails.targetElement != CalendarElement.appointment) {
      return;
    }

    setState(() {
      _selectedAppointment = null;
      _eventid = '';
      _isAllDay = false;
      _subject = '';
      _notes = '';
      if (_controller.view == CalendarView.month) {
        _controller.view = CalendarView.day;
      } else {
        if (calendarTapDetails.appointments != null &&
            calendarTapDetails.appointments.length == 1) {
          final Meeting meetingDetails = calendarTapDetails.appointments[0];
          _eventid = meetingDetails.eventId;
          _startDate = meetingDetails.from;
          _endDate = meetingDetails.to;
          _isAllDay = meetingDetails.isAllDay;
          _subject = meetingDetails.eventName == '(No title)'
              ? ''
              : meetingDetails.eventName;
          _selectedAppointment = meetingDetails;
        } else {
          final DateTime date = calendarTapDetails.date;
          _startDate = date;
          _endDate = date.add(const Duration(hours: 1));
        }
        _startTime =
            TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
        _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
      }
    });
    String idvalue = _eventid;

    Navigator.of(context).pushNamed(
        Routes.appointment,
        arguments: idvalue);
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
  String getId(int index) {
    return appointments[index].id;
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
  Meeting({this.eventId, this.eventName, this.from, this.to, this.background, this.isAllDay});
  String eventId;
  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}