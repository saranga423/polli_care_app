import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/widgets/loaders/animation_loader.dart';
import '../constants/colors.dart';
import '../helpers/helper_functions.dart';

class FullScreenLoader {
  static void openLoadingDialog(String text, String animation) {
    showDialog(
      context: Get.overlayContext!,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Container(
          color: CHelperFunctions.isDarkMode(Get.context!)
              ? CColors.dark
              : CColors.white,
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: AnimationLoaderWidget(text: text, animation: animation),
          ),
        ),
      ),
    );
  }

  /// Stop the currently open loading dialog
  static void stopLoading() {
    Navigator.of(Get.overlayContext!).pop();
  }
}
