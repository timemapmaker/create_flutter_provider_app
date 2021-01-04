import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:noteapp/models/goal_model.dart';

class StackModel {
  final String id;
  final String stackName;

  StackModel(
      {
        @required this.id,
        @required this.stackName,
      });

  factory StackModel.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }

    String stackName = data['stackName'];

    return StackModel(
        id: documentId, stackName: stackName);
  }

  Map<String, dynamic> toMap() {
    return {
      'stackName': stackName,
    };
  }
}