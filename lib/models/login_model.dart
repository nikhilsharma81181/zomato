import 'package:flutter/material.dart';

class Country extends ChangeNotifier {
  var phoneNumber = TextEditingController();
  String countryCode = '91';
  String flag = '';
  var emailAddress = TextEditingController();
  var password = TextEditingController();

  getPhone(TextEditingController phone) {
    phoneNumber = phone;
    notifyListeners();
  }

  getCountryCode(String code, flg) {
    countryCode = code;
    flag = flg;
    notifyListeners();
  }

  getEmail(TextEditingController email, pass) {
    emailAddress = email;
    password = pass;
    notifyListeners();
  }
}
