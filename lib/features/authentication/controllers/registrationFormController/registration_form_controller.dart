import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/loaders/loaders.dart';
import '../../../../data/repositories/repositories.authentication/authentication_repository.dart';
import '../../../../data/repositories/user/user_repository.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../screens/models/user_model.dart';
import '../../screens/signup/widgets/verify_email.dart';

class RegistrationFormController extends GetxController {
  static RegistrationFormController get instance => Get.find();

  // Form Fields
  final username = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  // Observable Fields
  final hidePassword = true.obs;
  final privacyPolicy = false.obs;

  // Form Key
  final registrationFormKey = GlobalKey<FormState>();

  /// Clear Form
  void clearForm() {
    username.clear();
    email.clear();
    password.clear();
    confirmPassword.clear();
    hidePassword.value = true;
    privacyPolicy.value = false;
  }

  /// Register User
  Future<void> register() async {
    try {
      // Start Loader
      FullScreenLoader.openLoadingDialog(
        CTexts.processingInformation,
        CImages.processingAnimation,
      );

      // Check Internet
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        return;
      }

      // Password Match Check
      if (password.text.trim() != confirmPassword.text.trim()) {
        Loaders.errorSnackBar(
          title: CTexts.error,
          message: CTexts.passwordDoNotMatch,
        );
        FullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!registrationFormKey.currentState!.validate()) {
        FullScreenLoader.stopLoading();
        return;
      }

      // Privacy Policy Check
      if (!privacyPolicy.value) {
        Loaders.warningSnackBar(
          title: CTexts.acceptPrivacyPolicy,
          message: CTexts.inOrderToCreateAccount,
        );
        FullScreenLoader.stopLoading();
        return;
      }

      // ✅ Register in Firebase Auth
      final userCredential = await AuthenticationRepository.instance
          .registerWithEmailAndPassword(
            email.text.trim(),
            password.text.trim(),
          );

      // ✅ Save user data in Firestore
      final newUser = UserModel(
        id: userCredential.user!.uid,
        username: username.text.trim(),
        email: email.text.trim(),
      );

      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserRecord(newUser);

      // Stop Loader
      FullScreenLoader.stopLoading();

      // Success SnackBar
      Loaders.successSnackBar(
        title: CTexts.congratulations,
        message: CTexts.yourAccountHasBeenCreated,
      );

      // Navigate to Verify Email Screen
      Get.to(() => VerifyEmailScreen(email: email.text.trim()));
    } catch (e) {
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: CTexts.error, message: e.toString());
    }
  }
}
