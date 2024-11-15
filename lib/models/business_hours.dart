import 'package:flutter/material.dart';

class BusinessHours {
  final TimeOfDay openingTime;
  final TimeOfDay closingTime;
  final List<int> workingDays;

  const BusinessHours({
    required this.openingTime,
    required this.closingTime,
    required this.workingDays,
  });

  bool isWorkingDay(int weekday) => workingDays.contains(weekday);
}
