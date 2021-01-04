import 'package:flutter/material.dart';
import 'package:noteapp/app_localizations.dart';
import 'package:noteapp/models/goal_model.dart';
import 'package:noteapp/models/stack_model.dart';
import 'package:noteapp/models/screen_arguments_model.dart';
import 'package:noteapp/services/firestore_database.dart';
import 'package:provider/provider.dart';

class CreateEditGoalStack extends StatefulWidget {
  @override
  _CreateEditGoalStackState createState() => _CreateEditGoalStackState();
}

class _CreateEditGoalStackState extends State<CreateEditGoalStack> {
  TextEditingController _stackNameController;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  StackModel _stack;


  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final StackScreenArguments _stackScreenArguments = ModalRoute.of(context).settings.arguments;
    final StackModel _stackModel = _stackScreenArguments.stack;
    if (_stackModel != null) {
      _stack = _stackModel;
    }
    _stackNameController = TextEditingController(text: _stack != null ? _stack.stackName : "");
  }

  @override
  Widget build(BuildContext context) {
    final StackScreenArguments _stackScreenArguments = ModalRoute.of(context).settings.arguments;
    _stack = _stackScreenArguments.stack;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.cancel),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(_stack != null
            ? _stack.stackName //AppLocalizations.of(context).translate("todosCreateEditAppBarTitleEditTxt")
            : ""),//AppLocalizations.of(context).translate("todosCreateEditAppBarTitleNewTxt")),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  FocusScope.of(context).unfocus();
                  final firestoreDatabase = Provider.of<FirestoreDatabase>(context, listen: false);
                  firestoreDatabase.setStack(StackModel(
                      id: _stack != null ? _stack.id : documentIdFromCurrentDate(),
                      stackName: _stackNameController.text
                  ),  _stackScreenArguments.goal.id);
                  Navigator.of(context).pop();
                }
              },
              child: Text("Save")
          )
        ],
      ),
      body: Center(
        child: _buildForm(context),
      ),
    );
  }

  @override
  void dispose() {
    _stackNameController.dispose();
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
                controller: _stackNameController,
                style: Theme.of(context).textTheme.body1,
                validator: (value) => value.isEmpty
                    ? "Nothing here" //AppLocalizations.of(context).translate("todosCreateEditTaskNameValidatorMsg")
                    : null,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).iconTheme.color, width: 2)),
                    labelText: "Stack Name"//AppLocalizations.of(context).translate("todosCreateEditTaskNameTxt"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
