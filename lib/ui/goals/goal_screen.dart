import 'package:flutter/material.dart';
import 'package:noteapp/models/user_model.dart';
import 'package:noteapp/models/goal_model.dart';
import 'package:noteapp/widgets/color_picker.dart';
import 'package:noteapp/providers/auth_provider.dart';
import 'package:noteapp/routes.dart';
import 'package:noteapp/services/firestore_database.dart';
import 'package:noteapp/ui/todo/empty_content.dart';
import 'package:provider/provider.dart';

class goalScreen extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final firestoreDatabase = Provider.of<FirestoreDatabase>(context, listen: false);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: Container(
              color: Colors.blueGrey,
                child: Center(child: Text("tm", style:
                TextStyle(fontSize: Theme.of(context).textTheme.headline4.fontSize,letterSpacing: 1.5,
        )))),
        title: StreamBuilder(
            stream: authProvider.user,
            builder: (context, snapshot) {
              final UserModel user = snapshot.data;
              return Center(child:Text("Goals"));
            }),
        actions: <Widget>[
          StreamBuilder(
              stream: firestoreDatabase.goalStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<GoalModel> goals = snapshot.data;
                  return Container(
                    width: 0,
                    height: 0,
                  );
                }
              }),
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.setting);
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(
            Routes.create_edit_goal,
          );
        },
      ),
      bottomNavigationBar: bottomnav(),
      body: WillPopScope(
          onWillPop: () async => false, child: _buildBodySection(context)),
    );
  }

  Widget _buildBodySection(BuildContext context) {
    final firestoreDatabase = Provider.of<FirestoreDatabase>(context, listen: false);

    return StreamBuilder(
        stream: firestoreDatabase.goalStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<GoalModel> goals = snapshot.data;
            if (goals.isNotEmpty) {
              return ListView.separated(
                itemCount: goals.length,
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
                    key: Key(goals[index].id),
                    onDismissed: (direction) {
                      firestoreDatabase.deleteGoal(goals[index]);
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        backgroundColor: Theme
                            .of(context)
                            .appBarTheme
                            .color,
                        content: Text(
                          "Deleted" + goals[index].goalName,
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
                            firestoreDatabase.setGoal(goals[index]);
                          },
                        ),
                      ));
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                          radius: 18.0,
                          backgroundColor: DefaultgoalColor,
                          child: Padding(
                              padding: EdgeInsets.all(7.0),
                              child: Text('${index+1}'))
                    ),
                      title: Text(goals[index].goalName),
                      trailing: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.grey, size: 18.0,),
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              Routes.create_edit_goal, arguments:goals[index]
                            );
                          }
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            Routes.stacks, arguments: goals[index]
                        );
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
        });
  }
}

