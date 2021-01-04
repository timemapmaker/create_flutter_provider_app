import 'package:flutter/material.dart';
import 'package:noteapp/app_localizations.dart';
import 'package:noteapp/models/goal_model.dart';
import 'package:noteapp/services/firestore_database.dart';
import 'package:provider/provider.dart';
import 'package:noteapp/widgets/color_picker.dart';

class CreateEditGoalScreen extends StatefulWidget {
  @override
  _CreateEditGoalScreenState createState() => _CreateEditGoalScreenState();
}

class _CreateEditGoalScreenState extends State<CreateEditGoalScreen> {
  TextEditingController _goalNameController;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GoalModel _goal;
  //Color _goalColor;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final GoalModel _goalModel = ModalRoute.of(context).settings.arguments;
    if (_goalModel != null) {
      _goal = _goalModel;
    }

    _goalNameController = TextEditingController(text: _goal != null ? _goal.goalName : "");
    Color _goalColor = _goal != null ? _goal.goalColor : DefaultgoalColor;
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () {
              Navigator.of(context).pop();
              },
          ),
          title: Text(_goal != null
            ? _goal.goalName //AppLocalizations.of(context).translate("todosCreateEditAppBarTitleEditTxt")
            : ""),//AppLocalizations.of(context).translate("todosCreateEditAppBarTitleNewTxt")),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    FocusScope.of(context).unfocus();
                    final firestoreDatabase = Provider.of<FirestoreDatabase>(context, listen: false);
                    firestoreDatabase.setGoal(GoalModel(
                        id: _goal != null ? _goal.id : documentIdFromCurrentDate(),
                        goalName: _goalNameController.text
                    ));
                    //goalColor: LinearColorPicker().newcolor));
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
    _goalNameController.dispose();
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
                controller: _goalNameController,
                style: Theme.of(context).textTheme.body1,
                validator: (value) => value.isEmpty
                    ? "Nothing here" //AppLocalizations.of(context).translate("todosCreateEditTaskNameValidatorMsg")
                    : null,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).iconTheme.color, width: 2)),
                  labelText: "Goal title"//AppLocalizations.of(context).translate("todosCreateEditTaskNameTxt"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
