import '../../res/app_strings.dart';

class ValidatorUtils {
  ValidatorUtils._();

  static String? validateEmail(String? value) {
    bool isValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value!);
    print("isValid is $isValid");
    return isValid ? null : AppStrings.pleaseEnterAValidEmail;
  }

  String? validatePassword(String value) {
    return null;
  }
}
