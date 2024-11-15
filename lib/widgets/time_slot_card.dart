import 'package:flutter/material.dart';

class TimeSlotCard extends StatelessWidget {
  final DateTime dateTime;
  final bool isAvailable;
  final VoidCallback? onTap;
  final String formattedTime;

  const TimeSlotCard({
    Key? key,
    required this.dateTime,
    required this.isAvailable,
    this.onTap,
    required this.formattedTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: isAvailable ? onTap : null,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: isAvailable
                  ? [Colors.blue, Colors.blueAccent]
                  : [Colors.grey, Colors.grey],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                formattedTime,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isAvailable ? 'Available' : 'Unavailable',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
