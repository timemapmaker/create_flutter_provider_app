import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:noteapp/models/todo_model.dart';
import 'package:noteapp/models/event_model.dart';
import 'package:noteapp/models/user_model.dart';
import 'package:noteapp/models/goal_model.dart';
import 'package:noteapp/models/stacktodo_model.dart';
import 'package:noteapp/models/stacknote_model.dart';
import 'package:noteapp/models/stack_model.dart';
import 'package:noteapp/services/firestore_path.dart';
import 'package:noteapp/services/firestore_service.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

/*
This is the main class access/call for any UI widgets that require to perform
any CRUD activities operation in Firestore database.
This class work hand-in-hand with FirestoreService and FirestorePath.

Notes:
For cases where you need to have a special method such as bulk update specifically
on a field, then is ok to use custom code and write it here. For example,
setAllTodoComplete is require to change all todos item to have the complete status
changed to true.

 */
class FirestoreDatabase {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;


  final _firestoreService = FirestoreService.instance;

  //Method to create/update userModel
  Future<void> setUser(UserModel user) async => await _firestoreService.setData(
    path: FirestorePath.user(uid),
    data: user.toMap(),
  );

  //Method to create/update todoModel
  Future<void> setTodo(TodoModel todo) async => await _firestoreService.setData(
        path: FirestorePath.todo(uid, todo.id),
        data: todo.toMap(),
      );

  //Method to create/update eventModel
  Future<void> setEvent(EventModel event) async => await _firestoreService.setData(
    path: FirestorePath.event(uid, event.id),
    data: event.toMap(),
  );

  //Method to create/update goalModel
  Future<void> setGoal(GoalModel goal) async => await _firestoreService.setData(
    path: FirestorePath.goal(uid, goal.id),
    data: goal.toMap(),
  );

  //Method to create/update stackModel
  Future<void> setStack(StackModel stack, String goalId) async => await _firestoreService.setData(
    path: FirestorePath.goalstack(uid, goalId, stack.id),
    data: stack.toMap(),
  );

  //Method to create/update StackTodoModel
  Future<void> setStackTodo(StackTodoModel stacktodo, String goalId, String stackId) async => await _firestoreService.setData(
    path: FirestorePath.goalstacktodo(uid, goalId, stackId, stacktodo.id),
    data: stacktodo.toMap(),
  );

  //Method to create/update StackNoteModel
  Future<void> setStackNote(StackNoteModel stacknote, String goalId, String stackId) async => await _firestoreService.setData(
    path: FirestorePath.goalstacknote(uid, goalId, stackId, stacknote.id),
    data: stacknote.toMap(),
  );

  //Method to delete todoModel entry
  Future<void> deleteTodo(TodoModel todo) async {
    await _firestoreService.deleteData(path: FirestorePath.todo(uid, todo.id));
  }

  //Method to delete eventModel entry
  Future<void> deleteEvent(EventModel event) async {
    await _firestoreService.deleteData(path: FirestorePath.todo(uid, event.id));
  }

  //Method to delete goal entry
  Future<void> deleteGoal(GoalModel goal) async {
    await _firestoreService.deleteData(path: FirestorePath.goal(uid, goal.id));
  }

  //Method to delete stack entry
  Future<void> deleteStack(StackModel stack, String goalId) async {
    await _firestoreService.deleteData(path: FirestorePath.goalstack(uid, goalId, stack.id));
  }

  //Method to delete stacktodo entry
  Future<void> deleteStackTodo(StackTodoModel stacktodo, String goalId, String stackId) async {
    await _firestoreService.deleteData(path: FirestorePath.goalstacktodo(uid, goalId, stackId, stacktodo.id));
  }

  //Method to delete stacktodo entry
  Future<void> deleteStackNote(StackNoteModel stacknote, String goalId, String stackId) async {
    await _firestoreService.deleteData(path: FirestorePath.goalstacktodo(uid, goalId, stackId, stacknote.id));
  }

  //Method to retrieve todoModel object based on the given todoId
  Stream<TodoModel> todoStream({@required String todoId}) =>
      _firestoreService.documentStream(
        path: FirestorePath.todo(uid, todoId),
        builder: (data, documentId) => TodoModel.fromMap(data, documentId),
      );

  //Method to retrieve eventModel object based on the given eventId
  Stream<EventModel> eventStream({@required String eventId}) =>
      _firestoreService.documentStream(
        path: FirestorePath.event(uid, eventId),
        builder: (data, documentId) => EventModel.fromMap(data, documentId),
      );

  //Method to retrieve stackModel object based on the given stackId and goalid
  Stream<StackModel> stackStream({@required String goalId, String stackId}) =>
      _firestoreService.documentStream(
        path: FirestorePath.goalstack(uid, goalId, stackId),
        builder: (data, documentId) => StackModel.fromMap(data, documentId),
      );

  //Method to retrieve stacktodoModel object based on the given stackId and goalid
  Stream<StackTodoModel> stacktodoStream({@required String goalId, String stackId, String stacktodoId}) =>
      _firestoreService.documentStream(
        path: FirestorePath.goalstacktodo(uid, goalId, stackId, stacktodoId),
        builder: (data, documentId) => StackTodoModel.fromMap(data, documentId),
      );

  //Method to retrieve stacknoteModel object based on the given stackId and goalid
  Stream<StackNoteModel> stacknoteStream({@required String goalId, String stackId, String stacknoteId}) =>
      _firestoreService.documentStream(
        path: FirestorePath.goalstacknote(uid, goalId, stackId, stacknoteId),
        builder: (data, documentId) => StackNoteModel.fromMap(data, documentId),
      );

  //Method to retrieve all goals item from the same user based on uid
  Stream<List<GoalModel>> goalStream() => _firestoreService.collectionStream(
    path: FirestorePath.goals(uid),
    builder: (data, documentId) => GoalModel.fromMap(data, documentId),
  );

  //Method to retrieve all todos item from the same user based on uid
  Stream<List<TodoModel>> todosStream() => _firestoreService.collectionStream(
        path: FirestorePath.todos(uid),
        builder: (data, documentId) => TodoModel.fromMap(data, documentId),
      );

  //Method to retrieve all event item from the same user based on userid
  Stream<List<EventModel>> eventsStream() => _firestoreService.collectionStream(
    path: FirestorePath.events(uid),
    builder: (data, documentId) => EventModel.fromMap(data, documentId),
  );

  //Method to retrieve all stacks items from the same user based on uid and goalid
  Stream<List<StackModel>> goalstacksStream({@required String goalId}) => _firestoreService.collectionStream(
    path: FirestorePath.goalstacks(uid, goalId),
    builder: (data, documentId) => StackModel.fromMap(data, documentId),
  );

  //Method to retrieve all stacktodos items from the same user based on uid, goalid and stackid
  Stream<List<StackTodoModel>> goalstacktodosStream({@required String goalId, String stackId}) => _firestoreService.collectionStream(
    path: FirestorePath.goalstacktodos(uid, goalId, stackId),
    builder: (data, documentId) => StackTodoModel.fromMap(data, documentId),
  );

  //Method to retrieve all stacknotes items from the same user based on uid, goalid and stackid
  Stream<List<StackNoteModel>> goalstacknotesStream({@required String goalId, String stackId}) => _firestoreService.collectionStream(
    path: FirestorePath.goalstacknotes(uid, goalId, stackId),
    builder: (data, documentId) => StackNoteModel.fromMap(data, documentId),
  );

  //Method to collect all eventModels for a user
  Future<List<DocumentSnapshot>> allEvents() async {
    //List events;
    final List<DocumentSnapshot> querySnapshot = (await Firestore.instance
        .collection(FirestorePath.events(uid)).getDocuments()).documents;

    //events = querySnapshot/*.toList()*/;

    return querySnapshot;
  }

  //Method to mark all todoModel to be complete
  Future<void> setAllTodoComplete() async {
    final batchUpdate = Firestore.instance.batch();

    final querySnapshot = await Firestore.instance
        .collection(FirestorePath.todos(uid))
        .getDocuments();

    for (DocumentSnapshot ds in querySnapshot.documents) {
      batchUpdate.updateData(ds.reference, {'complete': true});
    }
    await batchUpdate.commit();
  }

  Future<void> deleteAllTodoWithComplete() async {
    final batchDelete = Firestore.instance.batch();

    final querySnapshot = await Firestore.instance
        .collection(FirestorePath.todos(uid))
        .where('complete', isEqualTo: true)
        .getDocuments();

    for (DocumentSnapshot ds in querySnapshot.documents) {
      batchDelete.delete(ds.reference);
    }
    await batchDelete.commit();
  }
}
