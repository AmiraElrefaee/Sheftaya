class AppRegex {
  static bool isEmailValid(String email) {
    return RegExp(
      r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$',
    ).hasMatch(email);
  }

  static bool isPasswordValid(String password) {
    return RegExp(
      r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$",
    ).hasMatch(password);
  }

  static bool isPhoneNumberValid(String phoneNumber) {
    return RegExp(r'^(010|011|012|015)[0-9]{8}$').hasMatch(phoneNumber);
  }

  static bool hasLowerCase(String password) {
    return RegExp(r'^(?=.*[a-z])').hasMatch(password);
  }

  static bool hasUpperCase(String password) {
    return RegExp(r'^(?=.*[A-Z])').hasMatch(password);
  }

  static bool hasNumber(String password) {
    return RegExp(r'^(?=.*?[0-9])').hasMatch(password);
  }

  static bool hasSpecialCharacter(String password) {
    return RegExp(r'^(?=.*?[@#$!%*?&])').hasMatch(password);
  }

  static bool hasMinLength(String password) {
    return RegExp(r'^(?=.{8,})').hasMatch(password);
  }

  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }
    if (!isEmailValid(email)) {
      return 'البريد الإلكتروني غير صحيح';
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }
    if (password.length < 8) {
      return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
    }
    if (!hasLowerCase(password)) {
      return 'كلمة المرور يجب أن تحتوي على حرف صغير على الأقل';
    }
    if (!hasUpperCase(password)) {
      return 'كلمة المرور يجب أن تحتوي على حرف كبير على الأقل';
    }
    if (!hasNumber(password)) {
      return 'كلمة المرور يجب أن تحتوي على رقم على الأقل';
    }
    if (!hasSpecialCharacter(password)) {
      return 'كلمة المرور يجب أن تحتوي على رمز خاص (#@!%*?&) على الأقل';
    }
    if (!isPasswordValid(password)) {
      return 'كلمة المرور يجب أن تحتوي على حرف كبير، صغير، رقم ورمز خاص';
    }
    return null;
  }

  static String? validatePhoneNumber(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      return 'رقم الهاتف مطلوب';
    }
    if (!isPhoneNumberValid(phoneNumber)) {
      return 'رقم الهاتف غير صحيح. يجب أن يبدأ بـ 010, 011, 012, أو 015 ويتكون من 11 رقم';
    }
    return null;
  }

  static String? validateFirstName(String? firstName) {
    if (firstName == null || firstName.isEmpty) {
      return 'الاسم الأول مطلوب';
    }
    if (firstName.length < 3) {
      return 'الاسم الأول يجب أن يكون 3 أحرف على الأقل';
    }
    return null;
  }

  static String? validateLastName(String? lastName) {
    if (lastName == null || lastName.isEmpty) {
      return 'اسم العائلة مطلوب';
    }
    if (lastName.length < 3) {
      return 'اسم العائلة يجب أن يكون 3 أحرف على الأقل';
    }
    return null;
  }

  static String? validateConfirmPassword(
    String? confirmPassword,
    String? password,
  ) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'تأكيد كلمة المرور مطلوب';
    }
    if (confirmPassword != password) {
      return 'كلمة المرور غير متطابقة';
    }
    return null;
  }

  static String? validateDateOfBirth(String? dateOfBirth) {
    if (dateOfBirth == null || dateOfBirth.isEmpty) {
      return 'تاريخ الميلاد مطلوب';
    }
    return null;
  }
}
