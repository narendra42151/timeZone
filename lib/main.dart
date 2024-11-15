// lib/main.dart
import 'package:flutter/material.dart';
import 'package:timezoneproblem/screens/reservation_screen.dart';
import 'package:timezoneproblem/services/timezone_service.dart';

void main() {
  TimezoneService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Timezone Reservation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
      home: const ReservationScreen(),
    );
  }
}

// lib/models/timezone_model.dart


// libimport 'package:flutter/material.dart';/models/business_hours.dart


// lib/services/timezone_service.dart



// lib/utils/time_handler.dart



// lib/widgets/timezone_picker.dart



// lib/widgets/time_slot_card.dart



// lib/screens/reservation_screen.dart

