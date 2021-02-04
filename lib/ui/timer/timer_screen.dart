import 'dart:math';

import 'package:flutter/material.dart';
import 'package:noteapp/models/user_model.dart';
import 'package:noteapp/models/event_model.dart';
import 'package:noteapp/providers/auth_provider.dart';
import 'package:noteapp/routes.dart';
import 'package:noteapp/services/firestore_database.dart';
import 'package:provider/provider.dart';
import 'package:noteapp/ui/todo/empty_content.dart';

class timerScreen extends StatelessWidget{
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
              return Center(child: Text(
                  "Current Activity"));
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
          onWillPop: () async => false, child: _timerSection(context)),
    );
  }


Widget _timerSection(BuildContext context) {
  final firestoreDatabase = Provider.of<FirestoreDatabase>(context, listen: false);

  return Column(
      children: [
        Expanded(
            child: StreamBuilder(
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
                        backgroundColor: Colors.orange,
                        child: Padding(
                            padding: EdgeInsets.all(7.0),
                            child: Text('${index+1}'))
                    ),
                    title: Text(events[index].eventName),
                    trailing: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.grey, size: 18.0,),
                        onPressed: () {

                        }
                    ),
                    onTap: () {

                    },
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(height: 0.5, color: Colors.grey,);
              },
            );
          } else {
            return
              EmptyContentWidget(
                title: "Nothing here",
                message: "Push + to add a goal",
              );
          }
        } else if (snapshot.hasError) {
          return
            EmptyContentWidget(
              title: "Something went wrong",
              message: "Can't load data right now",
            );
        }
        return Center(child: CircularProgressIndicator());
      })
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height*0.35,
              child: Card(
              clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.arrow_drop_down_circle),
                        title: Text('Card title 1',
                            style: TextStyle(color: Colors.black.withOpacity(0.6))),
                        subtitle: Text(
                          'Secondary Text',
                          style: TextStyle(color: Colors.black.withOpacity(0.6)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: LinearProgressIndicator(),
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.start,
                        children: [
                          FlatButton(
                            onPressed: () {
                              // Perform some action
                               },
                            child: const Text('ACTION 1'),
                          ),
                          FlatButton(
                            onPressed: () {
                              // Perform some action
                              },
                            child: const Text('ACTION 2'),
                          ),
                        ],
                      ),
                      ],
                  )),
        ),
      ]
  );
  }
}
