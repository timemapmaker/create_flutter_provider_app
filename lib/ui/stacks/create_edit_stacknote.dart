import 'package:flutter/material.dart';
import 'package:noteapp/app_localizations.dart';
import 'package:noteapp/models/stacknote_model.dart';
import 'package:noteapp/models/screen_arguments_model.dart';
import 'package:noteapp/services/firestore_database.dart';
import 'package:provider/provider.dart';

class CreateEditStackNote extends StatefulWidget {
  @override
  _CreateEditStackNoteState createState() => _CreateEditStackNoteState();
}

class _CreateEditStackNoteState extends State<CreateEditStackNote> {
  TextEditingController _titleController;
  TextEditingController _contentController;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  StackNoteModel _stacknote;


  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final StacktodoScreenArguments _stackScreenTodoArguments = ModalRoute.of(context).settings.arguments;
    final StackNoteModel _stacknoteModel = _stackScreenTodoArguments.stacknote;
    if (_stacknoteModel != null) {
      _stacknote = _stacknoteModel;
    }

    _titleController =
        TextEditingController(text: _stacknote != null ? _stacknote.title : "");
    _contentController =
        TextEditingController(text: _stacknote != null ? _stacknote.content : "");
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

                  firestoreDatabase.setStackNote(
                      StackNoteModel(
                          id: _stacknote != null
                              ? _stacknote.id
                              : documentIdFromCurrentDate(),
                          title: _titleController.text,
                          content: _contentController.text.length > 0
                              ? _contentController.text
                              : "",
                          ),
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
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Widget _buildForm(BuildContext context) {
    final StacktodoScreenArguments _stackScreenTodoArguments = ModalRoute.of(context).settings.arguments;
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
                controller: _titleController,
                style: Theme.of(context).textTheme.body1,
                validator: (value) => value.isEmpty
                    ? AppLocalizations.of(context).translate("todosCreateEditTaskNameValidatorMsg")
                    : null,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).iconTheme.color, width: 2)),
                  labelText: _stackScreenTodoArguments.stack.stackName + " Note Title",
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: TextFormField(
                  controller: _contentController,
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
            ],
          ),
        ),
      ),
    );
  }
}
