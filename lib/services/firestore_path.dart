/*
This class defines all the possible read/write locations from the Firestore database.
In future, any new path can be added here.
This class work together with FirestoreService and FirestoreDatabase.
 */

class FirestorePath {
  static String todo(String uid, String todoId) => 'users/$uid/todos/$todoId';
  static String todos(String uid) => 'users/$uid/todos';
  static String user(String uid) => 'users';
  static String goals(String uid) => 'users/$uid/goals';
  static String goal(String uid, String goalId) => 'users/$uid/goals/$goalId';
  static String goalstacks(String uid, String goalId) => 'users/$uid/goals/$goalId/stacks';
  static String goalstack(String uid, String goalId, String stackId) => 'users/$uid/goals/$goalId/stacks/$stackId';
  static String goalstacktodos(String uid, String goalId, String stackId) => 'users/$uid/goals/$goalId/stacks/$stackId/todos';
  static String goalstacknotes(String uid, String goalId, String stackId) => 'users/$uid/goals/$goalId/stacks/$stackId/notes';
  static String goalstacktodo(String uid, String goalId, String stackId, String todoId) => 'users/$uid/goals/$goalId/stacks/$stackId/todos/$todoId';
  static String goalstacknote(String uid, String goalId, String stackId, String noteId) => 'users/$uid/goals/$goalId/stacks/$stackId/notes/$noteId';
  static String inboxstacks(String uid) => 'users/$uid/inbox';
  static String inboxstack(String uid, String istackId) => 'users/$uid/inbox/$istackId';
  static String inboxtodos(String uid, String istackId) => 'users/$uid/inbox/$istackId/todos';
  static String inboxnotes(String uid, String istackId) => 'users/$uid/inbox/$istackId/notes';
  static String inboxtodo(String uid, String istackId, String todoId) => 'users/$uid/inbox/$istackId/todos/$todoId';
  static String inboxnote(String uid, String istackId, String noteId) => 'users/$uid/inbox/$istackId/notes/$noteId';
}
