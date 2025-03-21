import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class BookingHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking History'),
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No bookings found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var booking = snapshot.data!.docs[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(
                    'Booking ${booking.id}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date: ${_formatDate(booking['date'])}'),
                      Text('Turf ID: ${booking['turfId']}'),
                      Text('Time: ${booking['startTime']} - ${booking['endTime']}'),
                      Text('Price: ₹${booking['totalPrice'].toStringAsFixed(2)}'),
                    ],
                  ),
                  trailing: Icon(Icons.sports_soccer, color: Colors.teal),
                  onTap: () {
                    // Navigate to a detailed booking page
                    _showBookingDetails(context, booking);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(String dateString) {
    DateTime date = DateTime.parse(dateString);
    return DateFormat('MMMM d, y').format(date);
  }

  void _showBookingDetails(BuildContext context, QueryDocumentSnapshot booking) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Booking Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Booking ID: ${booking.id}'),
                Text('Date: ${_formatDate(booking['date'])}'),
                Text('Turf ID: ${booking['turfId']}'),
                Text('Start Time: ${booking['startTime']}'),
                Text('End Time: ${booking['endTime']}'),
                Text('Total Price: ₹${booking['totalPrice'].toStringAsFixed(2)}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}