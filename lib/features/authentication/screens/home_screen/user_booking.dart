import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Please login to view bookings")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("My Bookings")),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("No bookings found"));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>? ?? {};
          final bookedMovies =
              (userData['bookedMovies'] as List<dynamic>? ?? [])
                  .cast<Map<String, dynamic>>();

          if (bookedMovies.isEmpty) {
            return const Center(child: Text("No bookings yet"));
          }

          // Sort bookings by date
          bookedMovies.sort(
            (a, b) => DateTime.parse(
              a['bookedAt'],
            ).compareTo(DateTime.parse(b['bookedAt'])),
          );

          final now = DateTime.now();
          final upcoming = bookedMovies
              .where((b) => DateTime.parse(b['bookedAt']).isAfter(now))
              .toList();
          final past = bookedMovies
              .where((b) => DateTime.parse(b['bookedAt']).isBefore(now))
              .toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (upcoming.isNotEmpty) ...[
                const Text(
                  "Upcoming Bookings",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...upcoming.map((b) => _buildBookingCard(b)),
                const SizedBox(height: 20),
              ],
              if (past.isNotEmpty) ...[
                const Text(
                  "Past Bookings",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...past.map((b) => _buildBookingCard(b)),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    final title = booking['title'] ?? 'Unknown Movie';
    final showtime = booking['showtime'] ?? 'N/A';
    final seats = (booking['seats'] as List<dynamic>? ?? []).join(', ');
    final bookedAt = booking['bookedAt'] ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title),
        subtitle: Text(
          "Showtime: $showtime\nSeats: $seats\nBooked At: $bookedAt",
        ),
        leading: const Icon(Icons.movie, color: Colors.blue),
      ),
    );
  }
}
