import 'package:flutter/material.dart';

Color resolveCategoryColor({
  required int? category,
  required ColorScheme colorScheme,
}) {
  switch (category) {
    case 1:
      return Colors.orange;
    case 2:
      return Colors.blue;
    case 3:
      return Colors.teal;
    case 4:
      return Colors.deepPurple;
    case 5:
      return Colors.green;
    case 6:
      return Colors.pink;
    case 7:
      return Colors.redAccent;
    case 8:
      return Colors.lightBlue;
    case 9:
      return Colors.indigo;
    case 10:
      return Colors.amber;
    default:
      return colorScheme.primary;
  }
}