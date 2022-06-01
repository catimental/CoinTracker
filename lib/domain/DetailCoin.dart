import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'coin/MarketData.dart';

class DetailCoin {
  late final String id;
  String? name;
  String? symbol;
  String? description;
  MarketData? _marketData;
  MarketData get marketData => _marketData!;

  DetailCoin(this.id) {
    _marketData = MarketData(this);
  }

  void updateFromJson(Map<String, dynamic> json) {
    name = json['name'];
    symbol = json['symbol'];
    description = json['description'];
  }

  Future<http.Response> _fetchInitializeDate() =>
      http.get(Uri.parse('https://api.coinpaprika.com/v1/coins/$id'),
          headers: {"Accept": "application/json"});

  void initialize() async {
    if (!isInitialized()) {
      var response = await _fetchInitializeDate();
      if (response.statusCode == 200) {
        var jsonString = json.decode(response.body);
        updateFromJson(jsonString);
      }
      if (kDebugMode) {
        print("$id initialized");
        print(this);
      }
    }
  }

  void update() async {
    if (!isInitialized()) {
      return;
    }
    if (kDebugMode) {
      // print("$id update");
    }
    _marketData!.update();
  }

  @override
  String toString() {
    return """id: $id
      name: $name
      symbol: $symbol
      description: $description 
    """;
  }

  bool isInitialized() => name != null;
}
