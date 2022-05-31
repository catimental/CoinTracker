import 'package:coin_tracker/domain/Coin.dart';
import 'package:flutter/material.dart';

class AppendedCoinIds with ChangeNotifier {
  List<String> _coins = [];

  List<String> get coins => _coins;
  void addCoin(String id) {
    if (!isExist(id)) {
      _coins.add(id);
      notifyListeners();
      print(id);
    }
  }

  void removeCoin(String id) {
    if (isExist(id)) {
      _coins.remove(id);
      notifyListeners();
    }
  }

  bool isExist(String id) {
    return _coins.contains(id);
  }
}
