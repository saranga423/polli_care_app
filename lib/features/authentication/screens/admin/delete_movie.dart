import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DeletePastMoviesScreen extends StatefulWidget {
  const DeletePastMoviesScreen({super.key});

  @override
  State<DeletePastMoviesScreen> createState() => _DeletePastMoviesScreenState();
}

class _DeletePastMoviesScreenState extends State<DeletePastMoviesScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Map<String, bool> selectedMovies = {}; // movieId -> selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Movies to Delete")),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('admin_movies').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("No movies found"));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final movie = docs[index];
                    final movieId = movie.id;
                    final title = movie['title'] ?? 'Untitled';

                    return CheckboxListTile(
                      title: Text(title),
                      subtitle: Text(movie['genre'] ?? ''),
                      value: selectedMovies[movieId] ?? false,
                      onChanged: (val) {
                        setState(() {
                          selectedMovies[movieId] = val ?? false;
                        });
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () async {
                    final toDelete = selectedMovies.entries
                        .where((e) => e.value)
                        .map((e) => e.key)
                        .toList();

                    if (toDelete.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("No movies selected")),
                      );
                      return;
                    }

                    for (var id in toDelete) {
                      await firestore
                          .collection('admin_movies')
                          .doc(id)
                          .delete();
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Selected movies deleted")),
                    );

                    setState(() {
                      selectedMovies.clear();
                    });
                  },
                  child: const Text("Delete Selected Movies"),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
