class Validators {
  static String? validatePositiveNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    final number = double.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }
    if (number <= 0) {
      return 'Please enter a positive number';
    }
    return null;
  }

  static String? nullCheck(String? value) {
    if (value == null || value.isEmpty) {
      return 'This Field is Required';
    }
    return null;
  }

  static String? validateNIC(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your NIC number';
    } else if (RegExp(r'^\d{9}[vVxX]$').hasMatch(value)) {
      return null;
    } else if (RegExp(r'^\d{12}$').hasMatch(value)) {
      return null;
    } else {
      return 'Please enter a valid NIC number';
    }
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your mobile number';
    } else if (!RegExp(r'^(\+94|0094)?07\d{8}$').hasMatch(value)) {
      return 'Please enter a valid Sri Lankan mobile number';
    }
    return null;
  }


  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 8) {
      return 'Password must be atleast 8 characters';
    }
    return null;
  }

  static String? validateWeight(String? value) {
    if (value != null && value.isNotEmpty) {
      final weight = double.tryParse(value);
      if (weight == null || weight < 0) {
        return 'Please enter a valid e-waste weight';
      }
    }
    return null;
  }
}
