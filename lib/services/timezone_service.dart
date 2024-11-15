import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezoneproblem/models/timeZone.dart';

class TimezoneService {
  static void initialize() {
    tz.initializeTimeZones();
  }

  static List<TimezoneModel> getAllTimezones() {
    final locations = tz.timeZoneDatabase.locations;
    return locations.entries.map((entry) {
      final parts = entry.key.split('/');
      final name = parts.last.replaceAll('_', ' ');
      final region = parts.length > 1 ? parts[0] : 'Other';

      return TimezoneModel(
        name: name,
        region: region,
        identifier: entry.key,
      );
    }).toList()
      ..sort((a, b) => a.region.compareTo(b.region));
  }

  static List<String> getRegions() {
    return getAllTimezones().map((tz) => tz.region).toSet().toList()..sort();
  }

  static String getCurrentTimezone() {
    return tz.local.name;
  }
}
