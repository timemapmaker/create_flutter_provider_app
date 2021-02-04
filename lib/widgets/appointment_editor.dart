import 'package:noteapp/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:noteapp/services/firestore_database.dart';
import 'package:provider/provider.dart';
import 'package:noteapp/models/stacktodo_model.dart';
import 'package:noteapp/models/screen_arguments_model.dart';


DateTime _startDate;
TimeOfDay _startTime;
DateTime _endDate;
TimeOfDay _endTime;
bool _isAllDay;
String _subject;
String _notes;
String _eventId;

class AppointmentEditor extends StatefulWidget {
  @override
  AppointmentEditorState createState() => AppointmentEditorState();
}

class AppointmentEditorState extends State<AppointmentEditor> {

  @override
  void initState() {
    _startDate = DateTime.now();
    _startTime = TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
    _endDate = _startDate.add(const Duration(hours: 1));
    _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
    _subject = '';
    _notes = 'Notes';
    _eventId='';
    _isAllDay = false;
    super.initState();
  }

  Widget _getAppointmentEditor(BuildContext context) {
    final firestoreDatabase = Provider.of<FirestoreDatabase>(context, listen: false);
    StackTodoModel _stacktodo = ModalRoute.of(context).settings.arguments;
    if (_stacktodo != null) {
    firestoreDatabase.eventdoc(eventId: _stacktodo.id).then((val) => setState(() {
      EventModel eventtoedit = val;
      _subject = eventtoedit.eventName;
      _startDate = eventtoedit.from;
      _endDate = eventtoedit.to;
      _isAllDay = eventtoedit.isAllDay;
    }));
        }

    return Container(
        //color: Colors.white,
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: <Widget>[
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
              leading: const Text(''),
              title: TextField(
                controller: TextEditingController(text: _subject),
                onChanged: (String value) {
                  _subject = value;
                },
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Add title',
                ),
              ),
            ),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
            ListTile(
                contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                leading: Icon(
                  Icons.access_time,
                  color: Colors.black54,
                ),
                title: Row(children: <Widget>[
                  const Expanded(
                    child: Text('All-day'),
                  ),
                  Expanded(
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Switch(
                            value: _isAllDay,
                            onChanged: (bool value) {
                              setState(() {
                                _isAllDay = value;
                              });
                            },
                          ))),
                ])),
            ListTile(
                contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                leading: const Text(''),
                title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 7,
                        child: GestureDetector(
                            child: Text(
                                DateFormat('EEE, MMM dd yyyy')
                                    .format(_startDate),
                                textAlign: TextAlign.left),
                            onTap: () async {
                              final DateTime date = await showDatePicker(
                                context: context,
                                initialDate: _startDate,
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100),
                              );

                              if (date != null && date != _startDate) {
                                setState(() {
                                  final Duration difference =
                                  _endDate.difference(_startDate);
                                  _startDate = DateTime(
                                      date.year,
                                      date.month,
                                      date.day,
                                      _startTime.hour,
                                      _startTime.minute,
                                      0);
                                  _endDate = _startDate.add(difference);
                                  _endTime = TimeOfDay(
                                      hour: _endDate.hour,
                                      minute: _endDate.minute);
                                }
                                );
                              }
                            }
                            ),

                      ),
                      Expanded(
                          flex: 3,
                          child: _isAllDay
                              ? const Text('')
                              : GestureDetector(
                              child: Text(
                                DateFormat('hh:mm a').format(_startDate),
                                textAlign: TextAlign.right,
                              ),
                              onTap: () async {
                                final TimeOfDay time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay(
                                        hour: _startTime.hour,
                                        minute: _startTime.minute));

                                if (time != null && time != _startTime) {
                                  setState(() {
                                    _startTime = time;
                                    final Duration difference =
                                    _endDate.difference(_startDate);
                                    _startDate = DateTime(
                                        _startDate.year,
                                        _startDate.month,
                                        _startDate.day,
                                        _startTime.hour,
                                        _startTime.minute,
                                        0);
                                    _endDate = _startDate.add(difference);
                                    _endTime = TimeOfDay(
                                        hour: _endDate.hour,
                                        minute: _endDate.minute);
                                  });
                                }
                              })),
                    ])),
           ListTile(
                contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                leading: const Text(''),
                title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 7,
                        child: GestureDetector(
                            child: Text(
                              DateFormat('EEE, MMM dd yyyy').format(_endDate),
                              textAlign: TextAlign.left,
                            ),
                            onTap: () async {
                              final DateTime date = await showDatePicker(
                                context: context,
                                initialDate: _endDate,
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100),
                              );

                              if (date != null && date != _endDate) {
                                setState(() {
                                  final Duration difference =
                                  _endDate.difference(_startDate);
                                  _endDate = DateTime(
                                      date.year,
                                      date.month,
                                      date.day,
                                      _endTime.hour,
                                      _endTime.minute,
                                      0);
                                  if (_endDate.isBefore(_startDate)) {
                                    _startDate = _endDate.subtract(difference);
                                    _startTime = TimeOfDay(
                                        hour: _startDate.hour,
                                        minute: _startDate.minute);
                                  }
                                });
                              }
                            }

                            ),
                      ),
                      Expanded(
                          flex: 3,
                          child: _isAllDay
                              ? const Text('')
                              : GestureDetector(
                              child: Text(
                                DateFormat('hh:mm a').format(_endDate),
                                textAlign: TextAlign.right,
                              ),
                              onTap: () async {
                                final TimeOfDay time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay(
                                        hour: _endTime.hour,
                                        minute: _endTime.minute));

                                if (time != null && time != _endTime) {
                                  setState(() {
                                    _endTime = time;
                                    final Duration difference =
                                    _endDate.difference(_startDate);
                                    _endDate = DateTime(
                                        _endDate.year,
                                        _endDate.month,
                                        _endDate.day,
                                        _endTime.hour,
                                        _endTime.minute,
                                        0);
                                    if (_endDate.isBefore(_startDate)) {
                                      _startDate =
                                          _endDate.subtract(difference);
                                      _startTime = TimeOfDay(
                                          hour: _startDate.hour,
                                          minute: _startDate.minute);
                                    }
                                  });
                                }
                              })),
                    ])),

            const Divider(
              height: 1.0,
              thickness: 1,
            ),
          ],
        ));
  }

  @override
  Widget build([BuildContext context]) {
    EventModel _event = null;
    //final EventModel _event = ModalRoute.of(context).settings.arguments;
    final firestoreDatabase = Provider.of<FirestoreDatabase>(context, listen: false);
    String idvalue = ModalRoute.of(context).settings.arguments;
    if (idvalue != null) {
      firestoreDatabase.eventdoc(eventId: idvalue).then((val) =>
          setState(() {
            EventModel _event = val;
          }));
    }
    return Scaffold(
            appBar: AppBar(
              title: Text(getTile()),
              backgroundColor: Colors.green,
              leading: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: <Widget>[
                IconButton(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    icon: const Icon(
                      Icons.done,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      final firestoreDatabase = Provider.of<FirestoreDatabase>(context, listen: false);
                      firestoreDatabase.setEvent(EventModel(
                        id: _event != null ? _event.id : documentIdFromCurrentDate(),
                        eventName: _subject == '' ? '(No title)' : _subject,
                        from: _startDate,
                        to: _endDate,
                        background: null,
                        description: _notes,
                        isAllDay: _isAllDay,
                      ));

                      Navigator.pop(context);
                    }
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
              child: Stack(
                children: <Widget>[_getAppointmentEditor(context)],
              ),
            ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.delete, color: Colors.white,),
            onPressed: () {
              final firestoreDatabase = Provider.of<FirestoreDatabase>(context, listen: false);
              firestoreDatabase.deleteEvent(_event);
              },
        ),
        );
  }

  String getTile() {
    return _subject.isEmpty ? 'New event' : 'Event details';
  }
}