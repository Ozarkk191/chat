final validPhone = RegExp(r'^(?:[+0]9)?[0-9]{10}$');

validationPhonenumberCheck(String value) {
  if (value.isEmpty) {
    return 'Phone Number can not empty.';
  } else if (value.length < 10) {
    return 'Phone Number must not be less than 10 characters.';
  } else if (value.substring(0, 2) != '08' &&
      value.substring(0, 2) != '09' &&
      value.substring(0, 2) != '06') {
    return 'Not a phone format.';
  } else if (value.length > 10) {
    return 'Phone Number cannot exceed 10 characters.';
  } else if (validPhone.hasMatch(value)) {
    return 'wrong';
  }
}
