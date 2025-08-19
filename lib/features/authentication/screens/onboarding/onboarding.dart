import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/helper_functions.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to LoginScreen after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Get.offAllNamed('/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(CSizes.defaultSpace),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Image
              Image(
                width: CHelperFunctions.screenWidth() * 0.8,
                height: CHelperFunctions.screenHeight() * 0.4,
                image: const AssetImage(CImages.onBoardingImage1),
              ),

              const SizedBox(height: CSizes.spaceBtwSections),

              /// Title
              Text(
                CTexts.onBoardingTitle1,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: CSizes.spaceBtwItems),

              /// Subtitle
              Text(
                CTexts.onBoardingSubTitle1,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: CSizes.spaceBtwSections),

              /// Optional Loading Indicator
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
