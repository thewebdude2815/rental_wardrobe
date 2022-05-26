String? validateName(String? name) {
  if (name == null) {
    return 'Name cannot be null';
  } else if (name.length < 6) {
    return 'Name should be more than 6 chars';
  } else {
    return null;
  }
}

String? validateNumber(String? number) {
  if (number == null) {
    return 'number cannot be null';
  } else if (number.length < 10) {
    return 'Number should be more than 10 chars';
  } else {
    return null;
  }
}

String? validatePassword(String? password) {
  if (password == null) {
    return 'Name cannot be null';
  } else if (password.length < 8) {
    return 'Password Should Be More Than 8 Chars';
  } else {
    return null;
  }
}

String? adminCode(String? code) {
  if (code == null) {
    return 'Name cannot be null';
  } else if (code != '2x4321') {
    return 'Wrong Admin Code';
  } else {
    return null;
  }
}

String? validateEmail(String? email) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = RegExp(pattern);
  if (email == null) {
    return 'Email cannot be null';
  } else if (!regExp.hasMatch(email)) {
    return 'Enter Valid Email';
  } else {
    return null;
  }
}

String? validateCity(String? cityName) {
  String pattern = r'^[0-9]*$';
  RegExp regExp = RegExp(pattern);
  if (cityName == null) {
    return 'City Name cannot be null';
  } else if (regExp.hasMatch(cityName)) {
    return 'Enter Valid City Name';
  } else {
    return null;
  }
}
