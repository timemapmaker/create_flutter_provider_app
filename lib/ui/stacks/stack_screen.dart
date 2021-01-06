import 'package:flutter/material.dart';
import 'package:noteapp/app_localizations.dart';
import 'package:noteapp/models/goal_model.dart';
import 'package:noteapp/widgets/color_picker.dart';
import 'package:noteapp/models/user_model.dart';
import 'package:noteapp/models/stack_model.dart';
import 'package:noteapp/models/screen_arguments_model.dart';
import 'package:noteapp/providers/auth_provider.dart';
import 'package:noteapp/routes.dart';
import 'package:noteapp/services/firestore_database.dart';
import 'package:noteapp/ui/todo/empty_content.dart';
import 'package:provider/provider.dart';

class stackScreen extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final firestoreDatabase = Provider.of<FirestoreDatabase>(context, listen: false);
    final GoalModel goal = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: StreamBuilder(
            stream: authProvider.user,
            builder: (context, snapshot) {
              final UserModel user = snapshot.data;
              return Text(goal.goalName + " > Stacks");
            }),
        actions: <Widget>[
          StreamBuilder(
              stream: firestoreDatabase.goalstacksStream(goalId: goal.id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<StackModel> stacks = snapshot.data;
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
            Routes.create_edit_stack, arguments: StackScreenArguments(goal, null)
          );
        },
      ),
      bottomNavigationBar: bottomnav(),
      body: _buildBodySection(context)
    );
  }

  Widget _buildBodySection(BuildContext context) {
    final firestoreDatabase = Provider.of<FirestoreDatabase>(context, listen: false);
    GoalModel goal = ModalRoute.of(context).settings.arguments;
    final StackScreenArguments args = StackScreenArguments(goal, null);

    return StreamBuilder(
        stream: firestoreDatabase.goalstacksStream(goalId: goal.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<StackModel> stacks = snapshot.data;
            if (stacks.isNotEmpty) {
              return ListView.separated(
                itemCount: stacks.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    background: Container(
                      color: Colors.red,
                      child: Center(
                          child: Text(
                            AppLocalizations.of(context).translate(
                                "todosDismissibleMsgTxt"),
                            style: TextStyle(color: Theme
                                .of(context)
                                .canvasColor),
                          )),
                    ),
                    key: Key(stacks[index].id),
                    onDismissed: (direction) {
                      firestoreDatabase.deleteStack(stacks[index], goal.id);
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        backgroundColor: Theme
                            .of(context)
                            .appBarTheme
                            .color,
                        content: Text(goal.goalName,
                          style:
                          TextStyle(color: Theme
                              .of(context)
                              .canvasColor),
                        ),
                        duration: Duration(seconds: 3),
                        action: SnackBarAction(
                          label: AppLocalizations.of(context).translate(
                              "todosSnackBarActionLbl"),
                          textColor: Theme
                              .of(context)
                              .canvasColor,
                          onPressed: () {
                          },
                        ),
                      ));
                    },
                    child: ListTile(
                      leading: Icon(Icons.library_books, color: DefaultgoalColor,),
                      title: Text(stacks[index].stackName),
                      trailing: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.grey, size: 18.0,),
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                                Routes.create_edit_stack, arguments:StackScreenArguments(args.goal, stacks[index])
                            );
                          }
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            Routes.stackdetails,arguments: StackScreenArguments(args.goal, stacks[index])
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
              return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        Text("Break down your goal into stacks."),
                        Text("Push + to add a stack")]));
            }
          } else if (snapshot.hasError) {
            return
              EmptyContentWidget(
                title: AppLocalizations.of(context).translate("todosErrorTopMsgTxt"),
                message: AppLocalizations.of(context).translate("todosErrorBottomMsgTxt"),
              );
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}

