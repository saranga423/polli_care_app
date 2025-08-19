import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../../data/repositories/repositories.authentication/authentication_repository.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/popups/loaders.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    sendEmailVerification();
    //  setTimerForAutoRedirect();
    super.onInit();
  }

  /// Send Email Verification Link
  sendEmailVerification() async {
    try {
      await AuthenticationRepository.instance.sendEmailVerification();
      TLoaders.successSnackBar(
        title: CTexts.emailSent,
        message: CTexts.pleaseCheckYourInboxAndVerifyYourEmail,
      );
    } catch (e) {
      TLoaders.errorSnackBar(title: CTexts.error, message: e.toString());
    }
  }

  /// Timer to automatically redirect on Email Verification
  // setTimerForAutoRedirect() {
  //   Timer.periodic(
  //     const Duration(seconds: 1),
  //     (timer) async {
  //       try {
  //         await FirebaseAuth.instance.currentUser?.reload();
  //         final user = FirebaseAuth.instance.currentUser;
  //         if (user != null && user.emailVerified) {
  //           timer.cancel();
  //           // Use userId as paymentId
  //           await _addPaymentToFirestore(user.uid);
  //           // After payment is updated, navigate to the PaymentPage
  //           // Get.off(() => rgistrationfee());
  //         }
  //       } catch (e) {
  //         timer.cancel();
  //         TLoaders.errorSnackBar(title: CTexts.error, message: e.toString());
  //       }
  //     },
  //   );
  // }

  /// Manually Check if Email Verified
  checkEmailVerificationStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.emailVerified) {
      // Use userId as paymentId
      // await _addPaymentToFirestore(currentUser.uid);
      // After payment is updated, navigate to the PaymentPage
      // Get.off(() => rgistrationfee());
    }
  }

  /// Method to update the payment status in Firestore
}
