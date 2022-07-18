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

  static String? validateName(String? value) {
    // var pattern = r'(^[a-zA-Z ]*$)';
    // var regExp = new RegExp(pattern);
    if (value!.isEmpty) {
      return "Name is Required";
    } else if (value.length < 3){
      return "Name must be greater than 2 letters";
    }
    // else if (!regExp.hasMatch(value.trim())) {
    //   return "Name must be a-z and A-Z";
    // }
    return null;
  }

  static String? validatePassword(String? pass1) {
    RegExp hasUpper = RegExp(r'[A-Z]');
    RegExp hasLower = RegExp(r'[a-z]');
    RegExp hasDigit = RegExp(r'\d');
    // RegExp hasPunct = RegExp(r'[_!@#\$&*~-]');
    if (!RegExp(r'.{8,}').hasMatch(pass1!))
      return 'Passwords must have at least 8 characters';
    if (!hasUpper.hasMatch(pass1))
      return 'Passwords must have at least one uppercase character';
    if (!hasLower.hasMatch(pass1))
      return 'Passwords must have at least one lowercase character';
    if (!hasDigit.hasMatch(pass1))
      return 'Passwords must have at least one number';
    // if (!hasPunct.hasMatch(pass1))
    //   return 'Passwords need at least one special character like !@#\$&*~-';
    return null;
  }

  static String? validateMobilePhone(String? value) {
    var pattern = r'(^[0-9]*$)';
    var regExp = new RegExp(pattern);
    if (value!.isEmpty) {
      return "Phone number is Required";
    } else if (value.length < 10) {
      return "Phone number must be 10 digits";
    } else if (!regExp.hasMatch(value)) {
      return "Phone number must be digits";
    }
    return null;
  }

  static String? validatePhone(String? value) {
    return null;
  }


}
