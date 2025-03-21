import 'package:flutter/material.dart';

// Assuming you have a Booking model like this
class Booking {
  final String personName;
  final DateTime bookingTime;
  final int durationHours;

  Booking({
    required this.personName,
    required this.bookingTime,
    required this.durationHours,
  });
}

class ViewBookingsPage extends StatefulWidget {
  const ViewBookingsPage({super.key});

  @override
  _ViewBookingsPageState createState() => _ViewBookingsPageState();
}

class _ViewBookingsPageState extends State<ViewBookingsPage> {
  // This would be your data fetched from a database or backend
  List<Booking> bookings = [
    Booking(personName: 'John Doe', bookingTime: DateTime.now(), durationHours: 2),
    // Add more bookings here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Football Turf Bookings'),
      ),
      body: ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          Booking booking = bookings[index];
          return ListTile(
            title: Text(booking.personName),
            subtitle: Text('Booking Time: ${booking.bookingTime} for ${booking.durationHours} hours'),
          );
        },
      ),
    );
  }
}
