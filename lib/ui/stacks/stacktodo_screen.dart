import 'package:flutter/material.dart';
import 'package:noteapp/models/screen_arguments_model.dart';
import 'package:noteapp/models/stacktodo_model.dart';
import 'package:noteapp/providers/auth_provider.dart';
import 'package:noteapp/routes.dart';
import 'package:noteapp/services/firestore_database.dart';
import 'package:noteapp/ui/todo/empty_content.dart';
import 'package:provider/provider.dart';
import 'package:noteapp/widgets/appointment_editor.dart';

class stacktodoScreen extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final firestoreDatabase = Provider.of<FirestoreDatabase>(context, listen: false);
    final StackScreenArguments inargs = ModalRoute.of(context).settings.arguments;
    final StacktodoScreenArguments outargs=StacktodoScreenArguments(inargs.goal, inargs.stack, null, null);

    return Scaffold(
        key: _scaffoldKey,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed(
                Routes.create_edit_stacktodos, arguments: StacktodoScreenArguments(outargs.goal, outargs.stack, null, null)
            );
          },
        ),
        body: _buildBodySection(context)
    );
  }

  Widget _buildBodySection(BuildContext context) {
    final firestoreDatabase = Provider.of<FirestoreDatabase>(context, listen: false);
    final StackScreenArguments inargs = ModalRoute.of(context).settings.arguments;
    final StacktodoScreenArguments outargs=StacktodoScreenArguments(inargs.goal, inargs.stack, null, null);

    return StreamBuilder(
        stream: firestoreDatabase.goalstacktodosStream(goalId: inargs.goal.id, stackId: inargs.stack.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<StackTodoModel> stacktodos = snapshot.data;
            if (stacktodos.isNotEmpty) {
              return ListView.separated(
                itemCount: stacktodos.length,
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
                    key: Key(stacktodos[index].id),
                    onDismissed: (direction) {
                      firestoreDatabase.deleteStackTodo(stacktodos[index], inargs.goal.id, inargs.stack.id);
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        backgroundColor: Theme
                            .of(context)
                            .appBarTheme
                            .color,
                        content: Text("Deleted " + stacktodos[index].task,
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
                          },
                        ),
                      ));
                    },
                    child: ListTile(
                      leading:
                      Checkbox(
                          value: stacktodos[index].complete,
                          onChanged: (value) {
                          StackTodoModel stacktodo = StackTodoModel(
                              id: stacktodos[index].id,
                              task: stacktodos[index].task,
                              extraNote: stacktodos[index].extraNote,
                              complete: value);
                          firestoreDatabase.setStackTodo(stacktodo, inargs.goal.id, inargs.stack.id);
                        }),
                      title: Text(stacktodos[index].task),
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            Routes.create_edit_stacktodos,
                            arguments: StacktodoScreenArguments(outargs.goal, outargs.stack, stacktodos[index], null)
                        );
                      },
                      trailing: IconButton(
                          icon: const Icon(Icons.schedule_send, color: Colors.grey, size: 18.0,),
                          onPressed: () {
                            Navigator.push<Widget>(
                                context,
                                MaterialPageRoute(
                                builder: (BuildContext context) => AppointmentEditor()));
                          }
                      ),
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
                  title: "Nothing Here",
                  message: "Add a new item to get started",
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

