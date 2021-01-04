import 'package:flutter/material.dart';
import 'package:noteapp/app_localizations.dart';
import 'package:noteapp/models/user_model.dart';
import 'package:noteapp/models/screen_arguments_model.dart';
import 'package:noteapp/models/stacktodo_model.dart';
import 'package:noteapp/models/stacknote_model.dart';
import 'package:noteapp/providers/auth_provider.dart';
import 'package:noteapp/routes.dart';
import 'package:noteapp/services/firestore_database.dart';
import 'package:noteapp/ui/todo/empty_content.dart';
import 'package:provider/provider.dart';

class stacknoteScreen extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final firestoreDatabase = Provider.of<FirestoreDatabase>(context, listen: false);
    final StackScreenArguments inargs = ModalRoute.of(context).settings.arguments;
    final StacktodoScreenArguments outargs=StacktodoScreenArguments(inargs.goal, inargs.stack, null, null);

    return Scaffold(
        key: _scaffoldKey,
        /*appBar: AppBar(
          title: StreamBuilder(
              stream: authProvider.user,
              builder: (context, snapshot) {
                final UserModel user = snapshot.data;
                return Text((inargs.goal.goalName) + " > " + (inargs.stack.stackName));
              }),
          actions: <Widget>[
            StreamBuilder(
                stream: firestoreDatabase.goalstacknotesStream(goalId: inargs.goal.id, stackId: inargs.stack.id),
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
                }),
          ],
        ),*/
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed(
                Routes.create_edit_stacknotes, arguments: StacktodoScreenArguments(outargs.goal, outargs.stack, null, null)
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
        stream: firestoreDatabase.goalstacknotesStream(goalId: inargs.goal.id, stackId: inargs.stack.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<StackNoteModel> stacknotes = snapshot.data;
            if (stacknotes.isNotEmpty) {
              return ListView.separated(
                itemCount: stacknotes.length,
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
                    key: Key(stacknotes[index].id),
                    onDismissed: (direction) {
                      firestoreDatabase.deleteStackNote(stacknotes[index], inargs.goal.id, inargs.stack.id);
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        backgroundColor: Theme
                            .of(context)
                            .appBarTheme
                            .color,
                        content: Text(stacknotes[index].title,
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
                      title: Text(stacknotes[index].title),
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            Routes.create_edit_stacknotes,
                            arguments: StacktodoScreenArguments(outargs.goal, outargs.stack, null, stacknotes[index])
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
                  title: AppLocalizations.of(context).translate("todosEmptyTopMsgDefaultTxt"),
                  message: AppLocalizations.of(context).translate("todosEmptyBottomDefaultMsgTxt"),
                );
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
