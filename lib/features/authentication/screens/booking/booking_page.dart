import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'confirm_booking.dart';

class BookingScreen extends StatelessWidget {
  final Map<String, dynamic> movie;
  final String selectedShowtime;
  final DateTime selectedDate;

  const BookingScreen({
    super.key,
    required this.movie,
    required this.selectedShowtime,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Seat Selection',
      themeMode: ThemeMode.system,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: SeatSelectionScreen(
        movie: movie,
        selectedShowtime: selectedShowtime,
        selectedDate: selectedDate,
      ),
    );
  }
}

class SeatSelectionScreen extends StatefulWidget {
  final Map<String, dynamic> movie;
  final String selectedShowtime;
  final DateTime selectedDate;

  const SeatSelectionScreen({
    super.key,
    required this.movie,
    required this.selectedShowtime,
    required this.selectedDate,
  });

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  static const rowsFull = ['A', 'B', 'C', 'D'];
  static const rowsPrime = ['E', 'F'];
  static const seatsPerRowFull = 8;
  static const seatsPerRowPrime = 8;

  final Map<String, List<bool>> availableSeats = {};
  final Map<String, Set<int>> selectedSeats = {};
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  StreamSubscription? _bookedSeatsSubscription;

  @override
  void initState() {
    super.initState();

    // Initialize seats
    for (var row in rowsFull + rowsPrime) {
      availableSeats[row] = List<bool>.filled(8, true);
      selectedSeats[row] = {};
    }

    _loadBookedSeats();
  }

  void _loadBookedSeats() {
    final movieTitle = widget.movie['title'];
    final showtime = widget.selectedShowtime;
    final dateStr = DateFormat('yyyy-MM-dd').format(widget.selectedDate);

    _bookedSeatsSubscription = firestore.collection('Users').snapshots().listen(
      (snapshot) {
        for (var userDoc in snapshot.docs) {
          final bookedMovies =
              userDoc.data()['bookedMovies'] as List<dynamic>? ?? [];
          for (var booking in bookedMovies) {
            final bookedDate = booking['date'] ?? booking['bookedAt'];
            if (booking['title'] == movieTitle &&
                booking['showtime'] == showtime &&
                bookedDate.toString().startsWith(dateStr)) {
              final seats = booking['seats'] as List<dynamic>? ?? [];
              for (var seat in seats) {
                final s = seat.toString();
                final row = s[0];
                final number = int.parse(s.substring(1)) - 1;
                if (availableSeats[row] != null &&
                    number >= 0 &&
                    number < availableSeats[row]!.length) {
                  if (!mounted) return;
                  setState(() {
                    availableSeats[row]![number] = false;
                    selectedSeats[row]!.remove(number);
                  });
                }
              }
            }
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _bookedSeatsSubscription?.cancel();
    super.dispose();
  }

  Widget buildSeat(String row, int number) {
    bool isAvailable = availableSeats[row]![number];
    bool isSelected = selectedSeats[row]!.contains(number);

    final theme = Theme.of(context);
    Color seatColor;
    if (!isAvailable) {
      seatColor = Colors.grey;
    } else if (isSelected) {
      seatColor = Colors.blue;
    } else {
      seatColor = theme.brightness == Brightness.dark
          ? Colors.white
          : Colors.black12;
    }

    return GestureDetector(
      onTap: isAvailable
          ? () {
              setState(() {
                if (isSelected) {
                  selectedSeats[row]!.remove(number);
                } else {
                  selectedSeats[row]!.add(number);
                }
              });
            }
          : null,
      child: Container(
        width: 32,
        height: 32,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: seatColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.white12),
        ),
        alignment: Alignment.center,
        child: Text(
          '${number + 1}',
          style: TextStyle(
            color: !isAvailable ? Colors.white : Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildSeatRow(String row, int seatCount) =>
      Row(children: List.generate(seatCount, (index) => buildSeat(row, index)));

  Widget buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendBox(Colors.black12, "Available"),
        const SizedBox(width: 20),
        _legendBox(Colors.blue, "Selected"),
        const SizedBox(width: 20),
        _legendBox(Colors.grey, "Unavailable"),
      ],
    );
  }

  Widget _legendBox(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(7),
          ),
        ),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.brightness == Brightness.dark
          ? Colors.black
          : Colors.white,
      appBar: AppBar(
        title: Text('${widget.movie['title']} - ${widget.selectedShowtime}'),
        backgroundColor: theme.brightness == Brightness.dark
            ? Colors.black
            : Colors.blue,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            '⬆ SCREEN THIS WAY',
            style: TextStyle(
              color: theme.brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          const SizedBox(height: 14),
          buildLegend(),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _sectionTitle('RECLINER FULL (3250.00)'),
                  for (var row in rowsFull)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const SizedBox(width: 8),
                          Text(
                            row,
                            style: const TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          buildSeatRow(row, seatsPerRowFull),
                        ],
                      ),
                    ),
                  const SizedBox(height: 32),
                  _sectionTitle('RECLINER PRIME (3500.00)'),
                  for (var row in rowsPrime)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const SizedBox(width: 8),
                          Text(
                            row,
                            style: const TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          buildSeatRow(row, seatsPerRowPrime),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),
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
                    onPressed: () {
                      List<String> selected = [];
                      selectedSeats.forEach((row, seats) {
                        for (var s in seats) selected.add('$row${s + 1}');
                      });

                      if (selected.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("No seats selected!")),
                        );
                        return;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingConfirmationScreen(
                            movieTitle: widget.movie['title'],
                            showtime: widget.selectedShowtime,
                            seats: selected,
                            selectedDate: widget.selectedDate,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "Confirm Booking",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
