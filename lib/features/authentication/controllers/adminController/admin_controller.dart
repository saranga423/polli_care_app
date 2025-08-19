import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AdminController extends GetxController {
  // Form key
  final formKey = GlobalKey<FormState>();

  // Controllers
  final titleController = TextEditingController();
  final genreController = TextEditingController();
  final durationController = TextEditingController();
  final showtimesController = TextEditingController();
  final descriptionController = TextEditingController();

  // Image picker
  var imageFile = Rx<File?>(null);
  final picker = ImagePicker();

  /// Pick Image from gallery
  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    }
  }

  /// Upload Movie
  /// useStorage: if true, uploads poster to Firebase Storage, otherwise saves Base64
  /// showtimesList: optional pre-processed list of showtimes
  Future<void> uploadMovie({
    bool useStorage = false,
    List<String>? showtimesList,
  }) async {
    if (!formKey.currentState!.validate()) return;

    if (imageFile.value == null) {
      Get.snackbar(
        "Error",
        "Please select a poster image",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      String movieTitle = titleController.text.trim();
      String? posterUrlOrBase64;

      if (useStorage) {
        // Upload to Firebase Storage
        final storageRef = FirebaseStorage.instance.ref().child(
          "movie_posters/$movieTitle.jpg",
        );
        await storageRef.putFile(imageFile.value!);
        posterUrlOrBase64 = await storageRef.getDownloadURL();
      } else {
        // Save as Base64 in Firestore
        final bytes = await imageFile.value!.readAsBytes();
        posterUrlOrBase64 = base64Encode(bytes);
      }

      // If showtimesList not provided, convert from text field
      final finalShowtimes =
          showtimesList ??
          showtimesController.text
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();

      // Save movie details to Firestore
      await FirebaseFirestore.instance
          .collection("admin_movies")
          .doc(movieTitle)
          .set({
            "title": movieTitle,
            "genre": genreController.text.trim(),
            "duration": durationController.text.trim(),
            "description": descriptionController.text.trim(),
            "showtimes": finalShowtimes,
            useStorage ? "posterUrl" : "posterBase64": posterUrlOrBase64,
            "releaseDate": DateTime.now()
                .toIso8601String(), // store release date
            "createdAt": FieldValue.serverTimestamp(),
          });

      Get.snackbar(
        "Success",
        "Movie uploaded successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Clear form
      titleController.clear();
      genreController.clear();
      durationController.clear();
      showtimesController.clear();
      descriptionController.clear();
      imageFile.value = null;
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Delete past movies
  Future<void> deletePastMovies() async {
    final now = DateTime.now();
    final moviesSnapshot = await FirebaseFirestore.instance
        .collection('admin_movies')
        .get();

    for (var doc in moviesSnapshot.docs) {
      final dateStr = doc['releaseDate'] ?? doc['date'];
      if (dateStr != null) {
        final movieDate = DateTime.tryParse(dateStr);
        if (movieDate != null && movieDate.isBefore(now)) {
          await doc.reference.delete();
        }
      }
    }
  }

  /// Logout
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed('/login');
  }
}
