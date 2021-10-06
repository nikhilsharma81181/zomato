import 'package:flutter/material.dart';

class Variables extends ChangeNotifier {
  String restaurantId = '';

  getRestaurantId(String id) {
    restaurantId= id;
    notifyListeners();
  }
}