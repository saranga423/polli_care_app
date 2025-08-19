import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../home_screen/home_screen.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final String movieTitle;
  final String showtime;
  final List<String> seats;
  final DateTime selectedDate;

  const BookingConfirmationScreen({
    super.key,
    required this.movieTitle,
    required this.showtime,
    required this.seats,
    required this.selectedDate,
  });

  Future<void> _confirmBooking(BuildContext context) async {
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;
    final user = auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please login first")));
      return;
    }

    final movieRef = firestore
        .collection('movies')
        .doc(movieTitle)
        .collection('showtimes')
        .doc(showtime);

    final userRef = firestore.collection('Users').doc(user.uid);

    final snapshot = await movieRef.get();
    final booked = snapshot.data()?['bookedSeats'] as List<dynamic>? ?? [];

    final conflict = seats.where((seat) => booked.contains(seat)).toList();
    if (conflict.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Already booked: ${conflict.join(', ')}")),
      );
      return;
    }

    await movieRef.set({
      'bookedSeats': FieldValue.arrayUnion(seats),
      'selectedDate': selectedDate.toIso8601String(),
    }, SetOptions(merge: true));

    await userRef.set({
      'bookedMovies': FieldValue.arrayUnion([
        {
          'title': movieTitle,
          'showtime': showtime,
          'seats': seats,
          'date': selectedDate.toIso8601String(),
          'bookedAt': DateTime.now().toIso8601String(),
        },
      ]),
    }, SetOptions(merge: true));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Seats booked for ${selectedDate.toLocal()}")),
    );

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.grey[100],
      appBar: AppBar(
        title: const Text("Booking Confirmation"),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// Ticket-like card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              margin: const EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    /// Movie Title
                    Text(
                      movieTitle,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Divider(thickness: 1, height: 24),

                    /// Details
                    Row(
                      children: [
                        const Icon(Icons.schedule, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          "Showtime: $showtime",
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          "Date: ${selectedDate.toLocal().toString().split(' ')[0]}",
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.event_seat, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Seats: ${seats.join(', ')}",
                            style: theme.textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            /// Spacer + Confirm Button
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
              onPressed: () => _confirmBooking(context),
              child: const Text(
                "Confirm & Pay",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
