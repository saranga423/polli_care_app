import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/widgets/loaders/animation_loader.dart';
import '../constants/colors.dart';
import '../helpers/helper_functions.dart';

class FullScreenLoader {
  static void openLoadingDialog(String text, String animation) {
    showDialog(
      context:
          Get.overlayContext!, // Use Get.overlayContext for overlay dialogs
      barrierDismissible:
          false, // The dialog can't be dismissed by tapping outside
      builder: (_) => PopScope(
        canPop: false, // Disable popping with the back button
        child: Container(
          color: CHelperFunctions.isDarkMode(Get.context!)
              ? CColors.dark
              : CColors.white,
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 250), // Adjust the spacing as needed
              AnimationLoaderWidget(text: text, animation: animation),
            ],
          ),
        ),
      ),
    );
  }

  /// Stop the currently open loading dialog
  /// This method doesn't return anything
  static stopLoading() {
    Navigator.of(
      Get.overlayContext!,
    ).pop(); // Close the dialog using the Navigator
  }
}
