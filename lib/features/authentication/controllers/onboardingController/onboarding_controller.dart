import 'package:get/get.dart';

class OnBoardingController extends GetxController {
  static OnBoardingController get instance => Get.find();

  RxBool isCompleted = false.obs;

  /// Mark onboarding as completed
  void completeOnBoarding() {
    isCompleted.value = true;
  }

  @override
  void onInit() {
    super.onInit();
    // Wait 3 seconds, then go to LoginScreen
    Future.delayed(const Duration(seconds: 3), () {
      completeOnBoarding();
      Get.offAllNamed("/login"); // ✅ Navigate to LoginScreen
    });
  }
}
