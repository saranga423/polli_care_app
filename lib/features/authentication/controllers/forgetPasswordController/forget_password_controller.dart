import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../data/repositories/repositories.authentication/authentication_repository.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../screens/password_configuration/reset_password.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  /// Variables
  final email = TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

  /// Send Reset Password Email
  sendPasswordResetEmail() async {
    try {
      // Start Loading
      FullScreenLoader.openLoadingDialog(
        CTexts.processingYourRequest,
        CImages.processingAnimation,
      );

      // Check Internet Connectivity
      // final isConnected = await NetworkManager.instance.isConnected();
      // if (!isConnected) {
      //   FullScreenLoader.stopLoading();
      //   return;
      // }

      // Form Validation
      if (!forgetPasswordFormKey.currentState!.validate()) {
        FullScreenLoader.stopLoading();
        return;
      }

      // Send Email to Reset Password
      await AuthenticationRepository.instance.sendPasswordResetEmail(
        email.text.trim(),
      );

      // Remove Loader
      FullScreenLoader.stopLoading();

      // Show Success Screen
      TLoaders.successSnackBar(
        title: CTexts.emailSent,
        message: CTexts.emailLinkSentToResetYourPassword.tr,
      );

      // Redirect
      Get.to(() => ResetPasswordScreen(email: email.text.trim()));
    } catch (e) {
      // Remove Loader
      FullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: CTexts.error, message: e.toString());
    }
  }

  resendPasswordResetEmail(String email) async {
    try {
      // Start Loading
      FullScreenLoader.openLoadingDialog(
        CTexts.processingYourRequest,
        CImages.processingAnimation,
      );

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        return;
      }

      // Send Email to Reset Password
      await AuthenticationRepository.instance.sendPasswordResetEmail(email);

      // Remove Loader
      FullScreenLoader.stopLoading();

      // Show Success Screen
      TLoaders.successSnackBar(
        title: CTexts.emailSent,
        message: CTexts.emailLinkSentToResetYourPassword.tr,
      );
    } catch (e) {
      // Remove Loader
      FullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: CTexts.error, message: e.toString());
    }
  }
}
