import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  /// Reactive variables
  var hidePassword = true.obs;
  var rememberMe = false.obs;

  /// Text Controllers
  final email = TextEditingController();
  final password = TextEditingController();

  /// Form Key
  final loginFormKey = GlobalKey<FormState>();

  /// Local Storage
  final localStorage = GetStorage();

  /// Admin Email
  final String adminEmail = 'admin@cinec.com';

  @override
  void onInit() {
    super.onInit();
    // Load stored email if Remember Me was previously checked
    String? storedEmail = localStorage.read('REMEMBER_ME_Email');
    email.text = storedEmail ?? '';
  }

  /// Email & Password login
  Future<void> emailAndPasswordSignIn() async {
    if (!loginFormKey.currentState!.validate()) return;

    try {
      // Save email if Remember Me selected
      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_Email', email.text.trim());
      } else {
        localStorage.remove('REMEMBER_ME_Email');
      }

      // Firebase login
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: email.text.trim(),
            password: password.text.trim(),
          );

      // Check if user is admin
      if (userCredential.user!.email == adminEmail) {
        // Navigate to Admin Dashboard
        Get.offAllNamed('/admin_dashboard');
      } else {
        // Navigate to regular Home Screen
        Get.offAllNamed('/home');
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Login Failed",
        e.message ?? "Unknown error",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
