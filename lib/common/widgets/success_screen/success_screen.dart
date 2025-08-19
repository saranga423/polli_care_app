import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../../styles/spacing_styles.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
    required this.onPressed,
  });

  final String image, title, subTitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyles.paddingWithAppBarHeight * 2,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final orientation = MediaQuery.of(context).orientation;
              double imageWidth = constraints.maxWidth * 0.6;

              if (orientation == Orientation.landscape) {
                imageWidth = constraints.maxWidth * 0.3;
              }

              bool isLottieFile = image.endsWith('.json');

              return Column(
                children: [
                  /// Image or Lottie Animation
                  if (isLottieFile)
                    Lottie.asset(image, width: imageWidth)
                  else
                    Image(image: AssetImage(image), width: imageWidth),
                  const SizedBox(height: CSizes.spaceBtwSections),

                  /// Title & SubTitle
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: CSizes.spaceBtwItems),
                  Text(
                    subTitle,
                    style: Theme.of(context).textTheme.labelMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: CSizes.spaceBtwItems),

                  /// Buttons
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onPressed,
                      child: const Text(CTexts.tContinue),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
