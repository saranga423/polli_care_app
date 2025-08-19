import 'dart:convert';

import 'package:cinec_movie_booking/features/authentication/screens/home_screen/upcoming.dart';
import 'package:cinec_movie_booking/features/authentication/screens/home_screen/user_booking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../movie/movie_detais.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Movies"),
        actions: [
          IconButton(
            icon: const Icon(Icons.upcoming),
            tooltip: "Upcoming",
            onPressed: () {
              Get.to(() => const UpcomingScreen());
            },
          ),
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: "My Bookings",
            onPressed: () {
              Get.to(() => const MyBookingsScreen());
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Get.offAllNamed('/login');
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('admin_movies')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No movies available"));
          }

          final movies = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movieDoc = movies[index];
              final movie = movieDoc.data()! as Map<String, dynamic>;

              final title = movie['title'] ?? '';
              final posterWidget = movie.containsKey('posterUrl')
                  ? Image.network(
                      movie['posterUrl'],
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : movie.containsKey('posterBase64')
                  ? Image.memory(
                      base64Decode(movie['posterBase64']),
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Center(child: Text("No poster")),
                    );

              return GestureDetector(
                onTap: () {
                  Get.to(() => MovieDetailsScreen(movie: movie));
                },
                child: Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      posterWidget,
                      Container(
                        width: double.infinity,
                        color: Colors.black54,
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
