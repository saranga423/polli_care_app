import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../booking/booking_page.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> movie;
  const MovieDetailsScreen({super.key, required this.movie});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  DateTime selectedDate = DateTime.now();

  void _goToBookingPage(String showtime) {
    Get.to(
      () => BookingScreen(
        movie: widget.movie,
        selectedShowtime: showtime,
        selectedDate: selectedDate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    // Poster widget
    Widget posterWidget;
    if (movie.containsKey('posterUrl') && movie['posterUrl'] != null) {
      posterWidget = Image.network(
        movie['posterUrl'],
        height: 250,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else if (movie.containsKey('posterBase64') &&
        movie['posterBase64'] != null) {
      posterWidget = Image.memory(
        base64Decode(movie['posterBase64']),
        height: 250,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else {
      posterWidget = Container(
        height: 250,
        color: Colors.grey[300],
        child: const Center(child: Text("No poster")),
      );
    }

    // Showtimes
    List<String> showtimesList = [];
    if (movie['showtimes'] != null && movie['showtimes'] is List<dynamic>) {
      showtimesList = (movie['showtimes'] as List<dynamic>)
          .map((e) => e.toString())
          .toList();
    }

    return Scaffold(
      appBar: AppBar(title: Text(movie['title'] ?? "Movie Details")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            posterWidget,
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    movie['title'] ?? '',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Genre & Duration
                  if (movie['genre'] != null)
                    Text(
                      "Genre: ${movie['genre']}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  if (movie['duration'] != null)
                    Text(
                      "Duration: ${movie['duration']}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  const SizedBox(height: 16),

                  // Short Description / Synopsis
                  if (movie['description'] != null)
                    Text(
                      movie['description'],
                      style: const TextStyle(fontSize: 16),
                    ),
                  const SizedBox(height: 24),

                  // Date Picker (7-day range)
                  const Text(
                    "Select Date",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 7,
                      itemBuilder: (context, index) {
                        final date = DateTime.now().add(Duration(days: index));
                        final isSelected =
                            date.day == selectedDate.day &&
                            date.month == selectedDate.month &&
                            date.year == selectedDate.year;
                        return GestureDetector(
                          onTap: () => setState(() => selectedDate = date),
                          child: Container(
                            width: 70,
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.blue
                                  : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  [
                                    "Sun",
                                    "Mon",
                                    "Tue",
                                    "Wed",
                                    "Thu",
                                    "Fri",
                                    "Sat",
                                  ][date.weekday % 7],
                                  style: TextStyle(
                                    fontSize: 14, // ✅ slightly smaller
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                Text(
                                  "${date.day}/${date.month}",
                                  style: TextStyle(
                                    fontSize: 14, //
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Showtimes buttons
                  if (showtimesList.isNotEmpty) ...[
                    const Text(
                      "Showtimes",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.start,
                      children: showtimesList.map((time) {
                        return SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            onPressed: () => _goToBookingPage(time),
                            child: Text(time),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
