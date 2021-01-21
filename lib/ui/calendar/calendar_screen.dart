import 'package:flutter/material.dart';
import 'package:noteapp/models/user_model.dart';
import 'package:noteapp/models/event_model.dart';
import 'package:noteapp/providers/auth_provider.dart';
import 'package:noteapp/routes.dart';
import 'package:noteapp/services/firestore_database.dart';
import 'package:provider/provider.dart';
import 'package:noteapp/ui/calendar/calendar_widget.dart';
import 'package:noteapp/ui/todo/empty_content.dart';



class calendarScreen extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final firestoreDatabase = Provider.of<FirestoreDatabase>(context, listen: false);
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
          onWillPop: () async => false, child:/*_buildcalendarbody(context)*/LoadDataFromFireStore()),
      //Container(child: EventCalendar()),
    );
  }

  Widget _buildcalendarbody(BuildContext context) {
    final firestoreDatabase = Provider.of<FirestoreDatabase>(context, listen: false);
    return StreamBuilder(
        stream: firestoreDatabase.eventsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
                List<EventModel> events = snapshot.data;
                if (events.isNotEmpty) {
                  return ListView.separated(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        background: Container(
                          color: Colors.red,
                          child: Center(
                              child: Text(
                                "Delete",
                                style: TextStyle(color: Theme
                                    .of(context)
                                    .canvasColor),
                              )),
                        ),
                        key: Key(events[index].id),
                        onDismissed: (direction) {
                          firestoreDatabase.deleteEvent(events[index]);
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            backgroundColor: Theme
                                .of(context)
                                .appBarTheme
                                .color,
                            content: Text(
                              "Deleted" + events[index].eventName,
                              style:
                              TextStyle(color: Theme
                                  .of(context)
                                  .canvasColor),
                            ),
                            duration: Duration(seconds: 3),
                            action: SnackBarAction(
                              label: "Undo",
                              textColor: Theme
                                  .of(context)
                                  .canvasColor,
                              onPressed: () {
                                firestoreDatabase.setEvent(events[index]);
                              },
                            ),
                          ));
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                              radius: 18.0,
                              backgroundColor: Colors.white,
                              child: Padding(
                                  padding: EdgeInsets.all(7.0),
                                  child: Text('${index + 1}'))
                          ),
                          title: Text(events[index].eventName),
                          trailing: IconButton(
                              icon: const Icon(
                                Icons.edit, color: Colors.grey, size: 18.0,),
                              onPressed: () {}
                          ),
                          onTap: () {},
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(height: 0.5, color: Colors.grey,);
                    },
                  );
                }
                else {
                  return Center(child: Text("No data"));
                }
              }
              else if (snapshot.hasError) {
                return EmptyContentWidget(
                    title: "Something went wrong",
                    message: "Can't load data right now",
                  );
              }
              return Center(child: Text("Some issue with the data"));
            }
        );


    /* StreamBuilder(
        stream: firestoreDatabase.eventsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<EventModel> querysnapshot = snapshot.data;
            List<Meeting> events = getDataFromDatabase(querysnapshot);
            _events = DataSource(events);
            return Scaffold(
                resizeToAvoidBottomInset: false,
                resizeToAvoidBottomPadding: false,
                body: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                    child: getEventCalendar(
                        _calendarView, _events,
                        onCalendarTapped)));
          }
          else{return Container(width: 0.0, height: 0.0);}
        });*/

  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}

