import 'package:flutter/material.dart';
import 'package:noteapp/app_localizations.dart';
import 'package:noteapp/models/stacktodo_model.dart';
import 'package:noteapp/models/screen_arguments_model.dart';
import 'package:noteapp/services/firestore_database.dart';
import 'package:provider/provider.dart';

class CreateEditStackTodo extends StatefulWidget {
  @override
  _CreateEditStackTodoState createState() => _CreateEditStackTodoState();
}

class _CreateEditStackTodoState extends State<CreateEditStackTodo> {
  TextEditingController _taskController;
  TextEditingController _extraNoteController;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  //final StacktodoScreenArguments args = null;
  StackTodoModel _stacktodo;
  bool _checkboxCompleted;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final StacktodoScreenArguments _stackScreenTodoArguments = ModalRoute.of(context).settings.arguments;
    final StackTodoModel _stacktodoModel = _stackScreenTodoArguments.stacktodo;
    if (_stacktodoModel != null) {
      _stacktodo = _stacktodoModel;
    }

    _taskController =
        TextEditingController(text: _stacktodo != null ? _stacktodo.task : "");
    _extraNoteController =
        TextEditingController(text: _stacktodo != null ? _stacktodo.extraNote : "");

    _checkboxCompleted = _stacktodo != null ? _stacktodo.complete : false;
  }

  @override
  Widget build(BuildContext context) {
    final StacktodoScreenArguments _stackScreenTodoArguments = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.cancel),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(_stackScreenTodoArguments.goal.goalName + ">" + _stackScreenTodoArguments.stack.stackName),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  FocusScope.of(context).unfocus();

                  final firestoreDatabase =
                  Provider.of<FirestoreDatabase>(context, listen: false);

                  firestoreDatabase.setStackTodo(
                      StackTodoModel(
                      id: _stacktodo != null
                          ? _stacktodo.id
                          : documentIdFromCurrentDate(),
                      task: _taskController.text,
                      extraNote: _extraNoteController.text.length > 0
                          ? _extraNoteController.text
                          : "",
                      complete: _checkboxCompleted),
                      _stackScreenTodoArguments.goal.id,
                      _stackScreenTodoArguments.stack.id);

                  Navigator.of(context).pop();
                }
              },
              child: Text("Save"))
        ],
      ),
      body: Center(
        child: _buildForm(context),
      ),
    );
  }

  @override
  void dispose() {
    _taskController.dispose();
    _extraNoteController.dispose();
    super.dispose();
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _taskController,
                style: Theme.of(context).textTheme.body1,
                validator: (value) => value.isEmpty
                    ? AppLocalizations.of(context).translate("todosCreateEditTaskNameValidatorMsg")
                    : null,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).iconTheme.color, width: 2)),
                  labelText: AppLocalizations.of(context).translate("todosCreateEditTaskNameTxt"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: TextFormField(
                  controller: _extraNoteController,
                  style: Theme.of(context).textTheme.body1,
                  maxLines: 15,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).iconTheme.color,
                            width: 2)),
                    labelText: AppLocalizations.of(context).translate("todosCreateEditNotesTxt"),
                    alignLabelWithHint: true,
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(AppLocalizations.of(context).translate("todosCreateEditCompletedTxt")),
                    Checkbox(
                        value: _checkboxCompleted,
                        onChanged: (value) {
                          setState(() {
                            _checkboxCompleted = value;
                          });
                        })
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
