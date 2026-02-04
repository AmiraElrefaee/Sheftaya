class AppRegex {
  static bool isEmailValid(String email) {
    return RegExp(
      r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$',
    ).hasMatch(email);
  }

  static bool isPasswordValid(String password) {
    return RegExp(
      r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$",
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
    return RegExp(r'^(?=.*?[@$!%*?&])').hasMatch(password);
  }

  static bool hasMinLength(String password) {
    return RegExp(r'^(?=.{8,})').hasMatch(password);
  }

  // دوال إرجاع رسائل الخطأ بالعربية

  /// التحقق من البريد الإلكتروني وإرجاع رسالة الخطأ
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }
    if (!isEmailValid(email)) {
      return 'البريد الإلكتروني غير صحيح';
    }
    return null;
  }

  /// التحقق من كلمة المرور وإرجاع رسالة الخطأ
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
      return 'كلمة المرور يجب أن تحتوي على رمز خاص (@!%*?&) على الأقل';
    }
    if (!isPasswordValid(password)) {
      return 'كلمة المرور يجب أن تحتوي على حرف كبير، صغير، رقم ورمز خاص';
    }
    return null;
  }

  /// التحقق من رقم الهاتف وإرجاع رسالة الخطأ
  static String? validatePhoneNumber(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      return 'رقم الهاتف مطلوب';
    }
    if (!isPhoneNumberValid(phoneNumber)) {
      return 'رقم الهاتف غير صحيح. يجب أن يبدأ بـ 010, 011, 012, أو 015 ويتكون من 11 رقم';
    }
    return null;
  }

  /// الحصول على رسالة متطلبات كلمة المرور
  static String getPasswordRequirements() {
    return 'كلمة المرور يجب أن تحتوي على:\n'
        '• 8 أحرف على الأقل\n'
        '• حرف كبير واحد على الأقل\n'
        '• حرف صغير واحد على الأقل\n'
        '• رقم واحد على الأقل\n'
        '• رمز خاص واحد على الأقل (@!%*?&)';
  }

  /// التحقق من الاسم الأول وإرجاع رسالة الخطأ
  static String? validateFirstName(String? firstName) {
    if (firstName == null || firstName.isEmpty) {
      return 'الاسم الأول مطلوب';
    }
    if (firstName.length < 3) {
      return 'الاسم الأول يجب أن يكون 3 أحرف على الأقل';
    }
    return null;
  }

  /// التحقق من اسم العائلة وإرجاع رسالة الخطأ
  static String? validateLastName(String? lastName) {
    if (lastName == null || lastName.isEmpty) {
      return 'اسم العائلة مطلوب';
    }
    if (lastName.length < 3) {
      return 'اسم العائلة يجب أن يكون 3 أحرف على الأقل';
    }
    return null;
  }

  /// التحقق من تأكيد كلمة المرور وإرجاع رسالة الخطأ
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

  /// التحقق من تاريخ الميلاد وإرجاع رسالة الخطأ
  static String? validateDateOfBirth(String? dateOfBirth) {
    if (dateOfBirth == null || dateOfBirth.isEmpty) {
      return 'تاريخ الميلاد مطلوب';
    }
    return null;
  }

  /// التحقق من نوع المستخدم وإرجاع رسالة الخطأ
  static String? validateUserType(String? userType) {
    if (userType == null || userType.isEmpty) {
      return '      نوع المستخدم مطلوب';
    }
    return null;
  }

  /// التحقق من الجنس وإرجاع رسالة الخطأ
  static String? validateGender(String? gender) {
    if (gender == null || gender.isEmpty) {
      return 'الجنس مطلوب';
    }
    return null;
  }
}
