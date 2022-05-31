import 'dart:async';

import 'package:coin_tracker/domain/Coin.dart';
import 'package:coin_tracker/domain/DetailCoin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppendedCoinIds with ChangeNotifier {
  Map<String, DetailCoin> _coins = {};
  Map<String, DetailCoin> get coins => _coins;
  bool _isUpdating = false;
  late Timer _timer;

  @override
  void dispose() {
    _isUpdating = false;
    _timer.cancel();
  }

  void addCoin(String id) {
    if (kDebugMode) {
      print('[add request]id: $id is_success: ${!isExist(id)}');
    }
    if (!isExist(id)) {
      _coins[id] = DetailCoin(id);
      notifyListeners();
    }
  }

  void removeCoin(String id) {
    if (kDebugMode) {
      print('[remove request] id: $id is_success: ${isExist(id)}');
    }
    if (isExist(id)) {
      _coins.remove(id);
      notifyListeners();
    }
  }

  bool isExist(String id) {
    return _coins.containsKey(id);
  }

  //todo thread Safe
  void updateStart() {
    _isUpdating = true;
    _coins.forEach((key, value) {
      value.initialize();
    });
    notifyListeners();
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      _coins.forEach((key, value) {
        value.update();
      });
      notifyListeners();
    });
  }

  void updateEnd() {
    if (_isUpdating) {
      _timer.cancel();
      _isUpdating = false;
    }
    notifyListeners();
  }
}
