import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UpcomingScreen extends StatelessWidget {
  const UpcomingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Center(child: Text("User not logged in"));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Upcoming Movies"), centerTitle: true),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.data() == null) {
            return const Center(child: Text("No upcoming movies found."));
          }

          final userData = snapshot.data!.data()! as Map<String, dynamic>;
          final bookedMovies =
              (userData['bookedMovies'] ?? []) as List<dynamic>;

          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);

          // Only keep user bookings with seats + title
          final upcomingMovies = bookedMovies.where((movie) {
            if (movie['title'] == null || movie['seats'] == null) return false;

            String? dateStr = movie['date'] ?? movie['bookedAt'];
            if (dateStr == null) return false;
            final movieDate = DateTime.tryParse(dateStr);
            return movieDate != null &&
                movieDate.isAfter(today.subtract(const Duration(days: 1)));
          }).toList();

          if (upcomingMovies.isEmpty) {
            return const Center(child: Text("No upcoming movies."));
          }

          // Sort by date ascending (today first → future)
          upcomingMovies.sort((a, b) {
            final dateA =
                DateTime.tryParse(a['date'] ?? a['bookedAt'] ?? '') ??
                DateTime.now();
            final dateB =
                DateTime.tryParse(b['date'] ?? b['bookedAt'] ?? '') ??
                DateTime.now();
            return dateA.compareTo(dateB);
          });

          return ListView.builder(
            itemCount: upcomingMovies.length,
            itemBuilder: (context, index) {
              final movie = upcomingMovies[index] as Map<String, dynamic>;
              final title = movie['title'] ?? 'Untitled';
              final showtime = movie['showtime'] ?? '';
              final seats = (movie['seats'] ?? []).join(', ');
              final dateStr = movie['date'] ?? movie['bookedAt'];
              final date = DateTime.tryParse(dateStr ?? '');
              final formattedDate = date != null
                  ? DateFormat('yyyy-MM-dd – kk:mm').format(date)
                  : 'Unknown date';

              final isToday =
                  date != null &&
                  date.year == now.year &&
                  date.month == now.month &&
                  date.day == now.day;

              return Card(
                color: isToday ? Colors.blue : null,
                margin: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.movie, size: 40),
                  title: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Date: $formattedDate\nShowtime: $showtime\nSeats: $seats",
                  ),
                  trailing: isToday
                      ? const Icon(Icons.today, color: Colors.redAccent)
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
