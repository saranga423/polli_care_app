import 'package:flutter/material.dart';

import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class CLoginHeader extends StatelessWidget {
  const CLoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = CHelperFunctions.isDarkMode(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Image(
            height: 150,
            image: AssetImage(
              dark ? CImages.lightAppLogo : CImages.darkAppLogo,
            ),
          ),
        ),
        Text(
          CTexts.loginTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: CSizes.sm),
        Text(
          CTexts.loginSubTitle,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: CSizes.md),
      ],
    );
  }
}
