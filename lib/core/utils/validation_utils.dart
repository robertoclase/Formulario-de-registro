class ValidationUtils {
  ValidationUtils._();

  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$',
    );
    return passwordRegex.hasMatch(password);
  }

  static bool isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^\+?[\d\s-()]{10,}$');
    return phoneRegex.hasMatch(phone);
  }

  static bool isNotEmpty(String? text) {
    return text != null && text.trim().isNotEmpty;
  }

  static bool hasMinLength(String text, int minLength) {
    return text.length >= minLength;
  }

  static bool hasMaxLength(String text, int maxLength) {
    return text.length <= maxLength;
  }
}