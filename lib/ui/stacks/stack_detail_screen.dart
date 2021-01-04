import 'package:flutter/material.dart';
import 'package:noteapp/app_localizations.dart';
import 'package:noteapp/models/goal_model.dart';
import 'package:noteapp/models/user_model.dart';
import 'package:noteapp/models/stack_model.dart';
import 'package:noteapp/models/screen_arguments_model.dart';
import 'package:noteapp/models/stacktodo_model.dart';
import 'package:noteapp/providers/auth_provider.dart';
import 'package:noteapp/routes.dart';
import 'package:noteapp/services/firestore_database.dart';
import 'package:noteapp/ui/stacks/stacknote_screen.dart';
import 'package:noteapp/ui/stacks/stacktodo_screen.dart';
import 'package:noteapp/ui/todo/empty_content.dart';
import 'package:provider/provider.dart';

class stackdetailScreen extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final firestoreDatabase = Provider.of<FirestoreDatabase>(
        context, listen: false);
    final StackScreenArguments inargs = ModalRoute
        .of(context)
        .settings
        .arguments;
    final StacktodoScreenArguments outargs = StacktodoScreenArguments(
        inargs.goal, inargs.stack, null, null);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: StreamBuilder(
              stream: authProvider.user,
              builder: (context, snapshot) {
                final UserModel user = snapshot.data;
                return Text(
                    (inargs.goal.goalName) + " > " + (inargs.stack.stackName));
              }),
          actions: <Widget>[
            StreamBuilder(
                stream: firestoreDatabase.goalstacktodosStream(
                    goalId: inargs.goal.id, stackId: inargs.stack.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<StackTodoModel> stacktodos = snapshot.data;
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
                }
            ),
          ],
          bottom: TabBar(//isScrollable: true,
              tabs:[
                Tab(text: "Tasks"),
                Tab(text: "Notes")
              ]
          ),
        ),
        bottomNavigationBar: bottomnav(),
        body: TabBarView(
            children: [
              Center(child: stacktodoScreen()),
              Center(child: stacknoteScreen()),
            ]
        ),
      ),
    );
  }
}

