import 'package:flutter/material.dart';
import 'package:timezoneproblem/models/timeZone.dart';
import 'package:timezoneproblem/services/timezone_service.dart';

class TimezonePicker extends StatefulWidget {
  final String currentTimezone;
  final ValueChanged<String> onTimezoneChanged;

  const TimezonePicker({
    Key? key,
    required this.currentTimezone,
    required this.onTimezoneChanged,
  }) : super(key: key);

  @override
  _TimezonePickerState createState() => _TimezonePickerState();
}

class _TimezonePickerState extends State<TimezonePicker> {
  late String selectedRegion;
  List<TimezoneModel> allTimezones = [];
  List<String> regions = [];

  @override
  void initState() {
    super.initState();
    allTimezones = TimezoneService.getAllTimezones();
    regions = TimezoneService.getRegions();
    selectedRegion = regions.first;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Select Timezone',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedRegion,
                isExpanded: true,
                items: regions.map((region) {
                  return DropdownMenuItem(
                    value: region,
                    child: Text(region),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedRegion = value;
                    });
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              itemCount: allTimezones
                  .where((tz) => tz.region == selectedRegion)
                  .length,
              itemBuilder: (context, index) {
                final timezone = allTimezones
                    .where((tz) => tz.region == selectedRegion)
                    .toList()[index];
                return ListTile(
                  title: Text(timezone.name),
                  subtitle: Text(timezone.identifier),
                  trailing: widget.currentTimezone == timezone.identifier
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () {
                    widget.onTimezoneChanged(timezone.identifier);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
