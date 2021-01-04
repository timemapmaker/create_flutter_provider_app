import 'package:flutter/material.dart';
import 'package:noteapp/ui/auth/register_screen.dart';
import 'package:noteapp/ui/auth/sign_in_screen.dart';
import 'package:noteapp/ui/goals/goal_screen.dart';
import 'package:noteapp/ui/stacks/stack_screen.dart';
import 'package:noteapp/ui/stacks/stack_detail_screen.dart';
import 'package:noteapp/ui/setting/setting_screen.dart';
import 'package:noteapp/ui/splash/splash_screen.dart';
import 'package:noteapp/ui/todo/create_edit_todo_screen.dart';
import 'package:noteapp/ui/goals/create_edit_goal_screen.dart';
import 'package:noteapp/ui/stacks/create_edit_stack.dart';
import 'package:noteapp/ui/stacks/stacktodo_screen.dart';
import 'package:noteapp/ui/stacks/create_edit_stacktodo.dart';
import 'package:noteapp/ui/stacks/stacknote_screen.dart';
import 'package:noteapp/ui/stacks/create_edit_stacknote.dart';
import 'package:noteapp/ui/todo/todos_screen.dart';

class Routes {
  Routes._(); //this is to prevent anyone from instantiate this object

  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String setting = '/setting';
  static const String create_edit_todo = '/create_edit_todo';
  static const String create_edit_goal = '/create_edit_goal';
  static const String create_edit_stack = '/create_edit_stack';
  static const String create_edit_stacktodos = '/create_edit_stacktodos';
  static const String create_edit_stacknotes = '/create_edit_stacknotes';
  static const String goals = '/goals';
  static const String stacks = '/stacks';
  static const String stacktodos = '/stacktodos';
  static const String stacknotes = '/stacknotes';
  static const String stackdetails = '/stackdetails';


  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => SplashScreen(),
    login: (BuildContext context) => SignInScreen(),
    register: (BuildContext context) => RegisterScreen(),
    home: (BuildContext context) => TodosScreen(),
    setting: (BuildContext context) => SettingScreen(),
    create_edit_todo: (BuildContext context) => CreateEditTodoScreen(),
    create_edit_goal: (BuildContext context) => CreateEditGoalScreen(),
    create_edit_stack: (BuildContext context) => CreateEditGoalStack(),
    goals: (BuildContext context) => goalScreen(),
    stacks: (BuildContext context) => stackScreen(),
    stacktodos: (BuildContext context) => stacktodoScreen(),
    create_edit_stacktodos: (BuildContext context) => CreateEditStackTodo(),
    stacknotes: (BuildContext context) => stacknoteScreen(),
    create_edit_stacknotes: (BuildContext context) => CreateEditStackNote(),
    stackdetails: (BuildContext context) => stackdetailScreen(),
  };
}


class bottomnav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Theme.of(context).canvasColor,
      height: 55.0,
      child: BottomAppBar(
        elevation: 20.0,
        color: Theme.of(context).appBarTheme.color, //Color.fromRGBO(64, 75, 96, .9),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home, color: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor),
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.goals);
              },
            ),
            IconButton(
              icon: Icon(Icons.calendar_today, color: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor, size: 20.0,),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.timer, color: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.move_to_inbox, color: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.view_compact, color: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor),
              onPressed: () {},
            )
          ],
        ),
        //shape: CircularNotchedRectangle(),
      ),
    );

  }
}

