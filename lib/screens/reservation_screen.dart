import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezoneproblem/models/business_hours.dart';
import 'package:timezoneproblem/services/timezone_service.dart';
import 'package:timezoneproblem/utils/time_handler.dart';
import 'package:timezoneproblem/widgets/time_slot_card.dart';
import 'package:timezoneproblem/widgets/timezone_picker.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({Key? key}) : super(key: key);

  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  late TimeHandler timeHandler;
  late BusinessHours businessHours;
  DateTime selectedDate = DateTime.now();
  String currentTimezone = TimezoneService.getCurrentTimezone();

  @override
  void initState() {
    super.initState();
    timeHandler = TimeHandler(businessTimezone: currentTimezone);
    businessHours = const BusinessHours(
      openingTime: TimeOfDay(hour: 9, minute: 0),
      closingTime: TimeOfDay(hour: 17, minute: 0),
      workingDays: [1, 2, 3, 4, 5],
    );
  }

  void _showTimezonePicker() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: TimezonePicker(
          currentTimezone: currentTimezone,
          onTimezoneChanged: (newTimezone) {
            setState(() {
              currentTimezone = newTimezone;
              timeHandler = TimeHandler(businessTimezone: currentTimezone);
            });
          },
        ),
      ),
    );
  }

  void _bookReservation(DateTime localDateTime) {
    if (!timeHandler.isBusinessOpen(localDateTime, businessHours)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Business Closed',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text('Please select a time during business hours.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // TODO: Implement booking logic
    print(
        'Booking for time: ${timeHandler.formatReservationTime(localDateTime)}');
  }

  @override
  Widget build(BuildContext context) {
    final availableSlots = timeHandler.getAvailableTimeSlots(
      date: selectedDate,
      slotDuration: const Duration(minutes: 30),
      hours: businessHours,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Reservation'),
        actions: [
          IconButton(
            icon: const Icon(Icons.schedule),
            onPressed: _showTimezonePicker,
            tooltip: 'Change Timezone',
          ),
        ],
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected Timezone: $currentTimezone',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Selected Date: ${DateFormat('MMM dd, yyyy').format(selectedDate)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(DateTime.now().year + 1),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Select Date'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: availableSlots.length,
                itemBuilder: (context, index) {
                  final slot = availableSlots[index];
                  final isAvailable =
                      timeHandler.isBusinessOpen(slot, businessHours);
                  final formattedTime = timeHandler.formatReservationTime(slot,
                      showTimezone: false);
                  return TimeSlotCard(
                    dateTime: slot,
                    isAvailable: isAvailable,
                    formattedTime: formattedTime,
                    onTap: isAvailable ? () => _bookReservation(slot) : null,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
