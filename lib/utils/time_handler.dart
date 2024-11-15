import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezoneproblem/models/business_hours.dart';

class TimeHandler {
  final String businessTimezone;

  TimeHandler({required this.businessTimezone});

  DateTime convertToBusinessTime(DateTime localDateTime) {
    final businessLocation = tz.getLocation(businessTimezone);
    final localLocation = tz.local;
    return tz.TZDateTime.from(localDateTime, businessLocation);
  }

  DateTime convertToLocalTime(DateTime businessDateTime) {
    final businessLocation = tz.getLocation(businessTimezone);
    final localLocation = tz.local;
    return tz.TZDateTime.from(businessDateTime, localLocation);
  }

  String formatReservationTime(DateTime dateTime, {bool showTimezone = true}) {
    final formatter = DateFormat('MMM dd, yyyy HH:mm');
    if (showTimezone) {
      final timezone = dateTime.timeZoneName;
      return '${formatter.format(dateTime)} $timezone';
    }
    return formatter.format(dateTime);
  }

  bool isBusinessOpen(DateTime localDateTime, BusinessHours hours) {
    final businessDateTime = convertToBusinessTime(localDateTime);

    if (!hours.isWorkingDay(businessDateTime.weekday)) {
      return false;
    }

    double currentHour = businessDateTime.hour + (businessDateTime.minute / 60);
    double openingHour =
        hours.openingTime.hour + (hours.openingTime.minute / 60);
    double closingHour =
        hours.closingTime.hour + (hours.closingTime.minute / 60);

    return currentHour >= openingHour && currentHour < closingHour;
  }

  List<DateTime> getAvailableTimeSlots({
    required DateTime date,
    required Duration slotDuration,
    required BusinessHours hours,
  }) {
    final List<DateTime> slots = [];

    final opening = DateTime(
      date.year,
      date.month,
      date.day,
      hours.openingTime.hour,
      hours.openingTime.minute,
    );

    final closing = DateTime(
      date.year,
      date.month,
      date.day,
      hours.closingTime.hour,
      hours.closingTime.minute,
    );

    DateTime currentSlot = opening;
    while (currentSlot.isBefore(closing)) {
      slots.add(currentSlot);
      currentSlot = currentSlot.add(slotDuration);
    }

    return slots;
  }
}
