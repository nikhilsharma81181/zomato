
import 'package:flutter/material.dart';

class RestaurantDetail extends ChangeNotifier {
  String restaurantId = '';

  getRestaurantId(String id) {
    restaurantId = id;
    notifyListeners();
  }
}
