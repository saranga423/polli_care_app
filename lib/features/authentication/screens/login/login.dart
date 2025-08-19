import 'package:cinec_movie_booking/features/authentication/screens/login/widgets/login_form.dart';
import 'package:cinec_movie_booking/features/authentication/screens/login/widgets/login_header.dart';
import 'package:flutter/material.dart';

import '../../../../common/styles/spacing_styles.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = CHelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: TSpacingStyles.paddingWithAppBarHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      /// Login Header
                      const CLoginHeader(),

                      const SizedBox(height: CSizes.spaceBtwSections),

                      /// Login Form
                      const CLoginForm(),

                      const SizedBox(height: CSizes.spaceBtwSections),
                    ],
                  ),

                  /// CircuitForge Signature
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
