import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class GoalModel {
  final String id;
  final String goalName;
  final Color goalColor;

  GoalModel(
      {@required this.id,
        @required this.goalName,
        this.goalColor
      });

  factory GoalModel.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }

    String goalName = data['goalName'];
    Color goalColor = data['goalColor'];

    return GoalModel(
        id: documentId, goalName: goalName, goalColor: goalColor);
  }

  Map<String, dynamic> toMap() {
    return {
      'goalName': goalName,
      'color': goalColor,
    };
  }
}