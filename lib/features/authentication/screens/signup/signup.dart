import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/validators/validation.dart';
import '../../controllers/registrationFormController/registration_form_controller.dart';
import '../../models/user_model.dart';
import '../login/login.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final controller = Get.put(RegistrationFormController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Iconsax.arrow_left),
        ),
        title: Text(
          CTexts.register,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(CSizes.defaultSpace),
        child: SingleChildScrollView(
          child: Form(
            key: controller.registrationFormKey,
            child: Column(
              children: [
                ///name
                TextFormField(
                  controller: controller.username,
                  validator: (value) => CValidator.validateEmptyText(
                    CTexts.nameWithInitials,
                    value,
                  ),
                  decoration: const InputDecoration(
                    labelText: CTexts.nameWithInitials,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
                const SizedBox(height: CSizes.spaceBtwInputFields),

                ///email
                TextFormField(
                  controller: controller.email,
                  validator: (value) => CValidator.validateEmail(value),
                  decoration: const InputDecoration(
                    labelText: CTexts.email,
                    prefixIcon: Icon(Iconsax.direct_right),
                  ),
                ),
                const SizedBox(height: CSizes.spaceBtwInputFields),
                Obx(
                  ///password
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
                const SizedBox(height: CSizes.spaceBtwSections),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (controller.registrationFormKey.currentState!
                          .validate()) {
                        try {
                          // Register with Firebase Auth
                          final auth = FirebaseAuth.instance;
                          final userCredential = await auth
                              .createUserWithEmailAndPassword(
                                email: controller.email.text.trim(),
                                password: controller.password.text.trim(),
                              );

                          final userId = userCredential.user!.uid;

                          // Save UserModel to Firestore
                          final newUser = UserModel(
                            id: userId,
                            username: controller.username.text.trim(),
                            email: controller.email.text.trim(),
                          );

                          await FirebaseFirestore.instance
                              .collection("Users")
                              .doc(userId)
                              .set(newUser.toJson());

                          Get.snackbar(
                            "Success",
                            "Account created successfully!",
                          );
                          controller.clearForm();
                          Get.offAll(const LoginScreen());
                        } catch (e) {
                          Get.snackbar(
                            "Error",
                            e.toString(),
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      }
                    },
                    child: const Text(CTexts.register),
                  ),
                ),
                const SizedBox(height: CSizes.spaceBtwSections),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      controller.clearForm();
                      Get.offAll(const LoginScreen());
                    },
                    child: const Text(CTexts.signIn),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
