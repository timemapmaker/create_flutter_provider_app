import 'package:noteapp/models/goal_model.dart';
import 'package:noteapp/models/user_model.dart';
import 'package:noteapp/models/stack_model.dart';
import 'package:noteapp/models/stacktodo_model.dart';


class StackScreenArguments {
  GoalModel goal;
  StackModel stack;
  StackScreenArguments(this.goal, this.stack);
}

class StacktodoScreenArguments {
  GoalModel goal;
  StackModel stack;
  StackTodoModel stacktodo;
  StacktodoScreenArguments(this.goal, this.stack, this.stacktodo);
}