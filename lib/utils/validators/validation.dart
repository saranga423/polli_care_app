import '../constants/text_strings.dart';

class CValidator {
  /// Empty Text Validation
  static String? validateEmptyText(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return '$fieldName ${CTexts.isRequired}';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return CTexts.emailIsRequired;
    }

    // Regular expression for email validation
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return CTexts.invalidEmailAddress;
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return CTexts.passwordisRequired;
    }

    // Check for minimum password length
    if (value.length < 6) {
      return CTexts.passwordMustBeAtLeast6CharactersLong;
    }

    // Check for uppercase letters
    // if (!value.contains(RegExp(r'[A-Z]'))) {
    //   return 'Password must contain at least one uppercase letter.';
    // }

    // Check for numbers
    if (!value.contains(RegExp(r'[0-9]'))) {
      return CTexts.passwordMustContainAtLeastOneNumber;
    }

    // Check for special characters
    // if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
    //   return 'Password must contain at least one special character.';
    // }

    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return CTexts.phoneNumberIsRequired;
    }

    // Regular expression for phone number validation (assuming a 10-digit US phone number format)
    final phoneRegExp = RegExp(r'^\d{10}$');

    if (!phoneRegExp.hasMatch(value)) {
      return CTexts.invalidPhoneNumberFormat;
    }

    return null;
  }

  // Add more custom validators as needed for your specific requirements.
}
