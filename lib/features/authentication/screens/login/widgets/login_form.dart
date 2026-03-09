import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/validators/validation.dart';
import '../../../controllers/loginController/login_controller.dart';
import '../../password_configuration/foget_password.dart';
import '../../signup/signup.dart';

class CLoginForm extends StatelessWidget {
  const CLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Form(
      key: controller.loginFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: CSizes.spaceBtwSections),
        child: Column(
          children: [
            /// Email Field
            TextFormField(
              controller: controller.email,
              validator: (value) => CValidator.validateEmail(value),
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: CTexts.email,
              ),
            ),
            const SizedBox(height: CSizes.spaceBtwInputFields),

            /// Password Field
            Obx(
              () => TextFormField(
                controller: controller.password,
                validator: (value) => CValidator.validatePassword(value),
                obscureText: controller.hidePassword.value,
                decoration: InputDecoration(
                  labelText: CTexts.password,
                  prefixIcon: const Icon(Iconsax.password_check),
                  suffixIcon: IconButton(
                    onPressed: () => controller.hidePassword.value =
                        !controller.hidePassword.value,
                    icon: Icon(
                      controller.hidePassword.value
                          ? Iconsax.eye_slash
                          : Iconsax.eye,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: CSizes.spaceBtwInputFields / 2),

            /// Remember Me & Forget Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Remember Me Checkbox
                Row(
                  children: [
                    Obx(
                      () => Checkbox(
                        value: controller.rememberMe.value,
                        onChanged: (value) => controller.rememberMe.value =
                            !controller.rememberMe.value,
                      ),
                    ),
                    const Text(CTexts.rememberMe),
                  ],
                ),

                /// Forget Password Button
                TextButton(
                  onPressed: () {
                    // Navigate to Forget Password screen
                    Get.to(() => const ForgetPasswordScreen());
                  },
                  child: const Text(CTexts.forgetPassword),
                ),
              ],
            ),
            const SizedBox(height: CSizes.spaceBtwSections),

            /// Sign In Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.emailAndPasswordSignIn(),
                child: const Text(CTexts.signIn),
              ),
            ),
            const SizedBox(height: CSizes.spaceBtwItems),

            /// Create Account Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Get.to(() => SignupScreen()),
                child: const Text(CTexts.createAccount),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
