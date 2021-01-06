import 'package:collection_ext/iterables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:noteapp/models/goal_model.dart' show GoalModel;
import 'package:noteapp/services/firestore_database.dart';

Iterable<Color> goalColors = [
  Colors.white,
  Color(0xFFF28C82),
  Color(0xFFFABD03),
  Color(0xFFFFF476),
  Color(0xFFCDFF90),
  Color(0xFFA7FEEB),
  Color(0xFFCBF0F8),
  Color(0xFFAFCBFA),
  Color(0xFFD7AEFC),
  Color(0xFFFDCFE9),
  Color(0xFFE6C9A9),
  Color(0xFFE9EAEE),
];
final DefaultgoalColor = Color(0xFFFABD03);


/// Goal color picker in a horizontal list style.
class LinearColorPicker extends StatelessWidget {

  /// Returns color of the goal, fallbacks to the default color.
  Color _currColor(GoalModel goal) => goal?.goalColor ?? DefaultgoalColor;
  Color newcolor = DefaultgoalColor;

  @override
  Widget build(BuildContext context) {
    GoalModel goal;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: goalColors.flatMapIndexed((i, color) => [
          if (i == 0) const SizedBox(width: 17),
          InkWell(
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white),
              ),
              child: color == _currColor(goal) ? const Icon(Icons.check, color: Colors.black) : null,
            ),
            onTap: () {
              if (color != _currColor(goal)) {
                Color newcolor = color;
              }
              return newcolor;
              },
          ),
          SizedBox(width: i == goalColors.length - 1 ? 17 : 20),
        ]).asList(),
      ),
    );


  }
}