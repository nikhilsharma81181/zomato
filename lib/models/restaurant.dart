import 'dart:async';

import 'package:flutter/material.dart';

class RestaurantDetail extends ChangeNotifier {
  String restaurantId = '';
  String restaurantName = '';
  bool showMenu = false;
  int menuIndex = 0;

  getRestaurantId(String id, name) {
    restaurantId = id;
    restaurantName = name;
    notifyListeners();
  }

  getMenuState(bool show) {
    showMenu = show;
    notifyListeners();
  }

  getIndex(int index) {
    menuIndex = index;
    notifyListeners();
  }

  final itemKey = GlobalKey();

  scrollToItem() {
    final context = itemKey.currentContext;
    Scrollable.ensureVisible(
      context!,
      alignment: 0,
      duration: const Duration(milliseconds: 400),
    );
  }
}

class CartItems extends ChangeNotifier {
  Map items = {};
  List itemList = [];
  int quantity = 0;
  int totalPrice = 0;
  Timer timer = Timer.periodic(const Duration(seconds: 1), (timer) {});
  String instructions = '';
  bool sendCutlery = false;

  perItemTotal(String name) {
    items[name]['totalPrice'] = items[name]['quantity'] * items[name]['price'];
    notifyListeners();
  }

  dsCutlery() {
    if (sendCutlery) {
      sendCutlery = false;
    } else {
      sendCutlery = true;
    }
    notifyListeners();
  }

  addInstructions(String text) {
    instructions = text;
    notifyListeners();
  }

  getExtra() {
    int num = 0;
    int price = 0;
    for (var item in itemList) {
      num = items[item]['quantity'] + num;
      price = items[item]['price'] * items[item]['quantity'] + price;
    }
    totalPrice = price;
    quantity = num;
    notifyListeners();
  }

  addItem(String name, int price, quantity, bool veg) {
    if (!itemList.contains(name)) {
      itemList.add(name);
    }
    if (!items.containsValue(name)) {
      items.update(
        name,
        (value) => {},
        ifAbsent: () => {},
      );
    }

    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      items.update(
        name,
        (value) => {
          'name': name,
          'price': price,
          'quantity': quantity,
          'veg': veg,
          'totalPrice': price,
        },
        ifAbsent: () => {},
      );
      getExtra();
      timer.cancel();
    });
    notifyListeners();
  }

  removeItem(String name) {
    if (itemList.contains(name)) {
      itemList.remove(name);
    }
    items.remove(name);
    getExtra();
    notifyListeners();
  }

  increaseQuantity(String name) {
    int num = items[name]['quantity'] ?? 0;
    items[name]['quantity'] = num + 1;
    perItemTotal(name);
    getExtra();
    notifyListeners();
  }

  decreaseQuantity(String name) {
    int num = items[name]['quantity'] ?? 0;
    items[name]['quantity'] = num - 1;
    perItemTotal(name);
    getExtra();
    notifyListeners();
  }
}


class Order {
  placeOrder() {
    
  }
}