import 'package:flutter/material.dart';

Color strngthenColor(Color color, double factor) {
  int r = (color.r * factor).clamp(0, 255).toInt();
  int g = (color.g * factor).clamp(0, 255).toInt();
  int b = (color.b * factor).clamp(0, 255).toInt();
  int a = (color.a).clamp(0, 255).toInt();
  return Color.fromARGB(a, r, g, b);
}

List<DateTime> generateWeekDates(int offset) {
  final today = DateTime.now();
  DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));
  startOfWeek = startOfWeek.add(Duration(days: offset * 7));
  return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
}

String ColorToStr(Color color) {
  return "${color.a}-${color.r}-${color.g}-${color.b}";
}

Color StrToColor(String color) {
  final [a, r, g, b] = color.split("-");
  return Color.from(
    alpha: double.parse(a),
    red: double.parse(r),
    green: double.parse(g),
    blue: double.parse(b),
  );
}

Color hextoRgb(String hex) {
  return Color(int.parse(hex, radix: 16) + 0xFF000000);
}
