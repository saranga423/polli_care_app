import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/adminController/admin_controller.dart';
import 'delete_movie.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await controller.logout();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Poster Image Picker
                GestureDetector(
                  onTap: () => controller.pickImage(),
                  child: Obx(
                    () => Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: controller.imageFile.value != null
                          ? Image.file(
                              controller.imageFile.value!,
                              fit: BoxFit.cover,
                            )
                          : const Center(child: Text("Tap to select poster")),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                TextFormField(
                  controller: controller.titleController,
                  validator: (value) =>
                      value!.isEmpty ? "Enter movie title" : null,
                  decoration: const InputDecoration(labelText: "Title"),
                ),
                const SizedBox(height: 16),

                // Genre
                TextFormField(
                  controller: controller.genreController,
                  validator: (value) => value!.isEmpty ? "Enter genre" : null,
                  decoration: const InputDecoration(labelText: "Genre"),
                ),
                const SizedBox(height: 16),

                // Duration
                TextFormField(
                  controller: controller.durationController,
                  validator: (value) =>
                      value!.isEmpty ? "Enter duration" : null,
                  decoration: const InputDecoration(labelText: "Duration"),
                ),
                const SizedBox(height: 16),

                // Showtimes
                TextFormField(
                  controller: controller.showtimesController,
                  validator: (value) =>
                      value!.isEmpty ? "Enter showtimes" : null,
                  decoration: const InputDecoration(
                    labelText:
                        "Showtimes (comma separated, e.g. 2.30 p.m, 5.00 p.m, 8.00 p.m)",
                  ),
                ),
                const SizedBox(height: 16),

                // Description
                TextFormField(
                  controller: controller.descriptionController,
                  validator: (value) =>
                      value!.isEmpty ? "Enter description" : null,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Short Description",
                  ),
                ),
                const SizedBox(height: 24),

                // Upload Movie Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (!controller.formKey.currentState!.validate()) return;

                      final showtimesList = controller.showtimesController.text
                          .split(',')
                          .map((e) => e.trim())
                          .where((e) => e.isNotEmpty)
                          .toList();

                      await controller.uploadMovie(
                        showtimesList: showtimesList,
                      );
                    },
                    child: const Text("Upload Movie"),
                  ),
                ),

                const SizedBox(height: 16),

                // Open Delete Past Movies Screen
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      Get.to(() => const DeletePastMoviesScreen());
                    },
                    child: const Text("Delete Past Movies"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
