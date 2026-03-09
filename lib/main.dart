// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
//
// import 'app.dart';
// import 'data/repositories/repositories.authentication/authentication_repository.dart';
// import 'firebase_options.dart';
//
// /// ---------- Entry Point of Flutter App ----------
// Future<void> main() async {
//   // Ensure Flutter bindings are initialized
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // Initialize Firebase
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//
//   Get.put(AuthenticationRepository());
//
//   // Initialize GetStorage (if using local storage)
//   await GetStorage.init();
//
//   // Run the App
//   runApp(const App());
// }
import 'package:flutter/material.dart';

import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pumpkin Flower Detector',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const HomePage(),
    );
  }
}
