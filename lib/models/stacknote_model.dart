import 'package:meta/meta.dart';

class StackNoteModel {
  final String id;
  final String title;
  final String content;

  StackNoteModel(
      {@required this.id,
        @required this.title,
        this.content,
      });

  factory StackNoteModel.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }

    String title = data['title'];
    String content = data['content'];

    return StackNoteModel(
        id: documentId, title: title, content: content);
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
    };
  }
}
