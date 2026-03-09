import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _image;
  String? _result;
  double? _confidence;
  bool _loading = false;

  final ImagePicker _picker = ImagePicker();

  final String apiUrl = "http://10.0.2.2:8000/predict";

  Future<void> pickImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _image = File(picked.path);
        _result = null;
        _confidence = null;
      });
    }
  }

  Future<void> uploadImage() async {
    if (_image == null) return;

    setState(() => _loading = true);

    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.files.add(
        await http.MultipartFile.fromPath('file', _image!.path),
      );

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = json.decode(responseBody);

        setState(() {
          _result = data['class'];
          _confidence = data['confidence'];
        });
      } else {
        setState(() {
          _result = "Server Error";
        });
      }
    } catch (e) {
      setState(() {
        _result = "Error: $e";
      });
      print(e);
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pumpkin Flower Checker"),
        backgroundColor: Colors.blue, // Blue AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Image display
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: _image != null
                  ? Image.file(_image!, height: 200, fit: BoxFit.cover)
                  : Container(
                      height: 200,
                      color: Colors.blue.shade50,
                      child: const Icon(
                        Icons.image,
                        size: 100,
                        color: Colors.grey,
                      ),
                    ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.photo, color: Colors.black),
                    label: const Text(
                      "Choose Image",
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: pickImage,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    icon: const Icon(Icons.search, color: Colors.black),
                    label: const Text(
                      "Check Flower",
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: uploadImage,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            if (_loading) const CircularProgressIndicator(),

            if (_result != null && !_loading)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        "Result: $_result",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_confidence != null)
                        Text(
                          "Confidence: ${(_confidence! * 100).toStringAsFixed(2)}%",
                          style: const TextStyle(fontSize: 18),
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
