import 'dart:convert';

import 'package:coin_tracker/domain/DetailCoin.dart';
import 'package:http/http.dart' as http;

class MarketData {
  final DetailCoin _detailCoin;
  double? price;
  double? percent_change_24h;
  String? lastUpdatedTime;

  MarketData(this._detailCoin);

  void updateFromJson(Map<String, dynamic> json) {
    // price = json['quotes']
    // print(json['quotes']['KRW']['price']);
    // price = ;
    price = json['quotes']['KRW']['price'];
    percent_change_24h = json['quotes']['KRW']['percent_change_24h'];
    lastUpdatedTime = json['last_updated'];
  }

  Future<http.Response> _fetchMarketDate() => http.get(
      Uri.parse(
          'https://api.coinpaprika.com/v1/tickers/${_detailCoin.id}/?quotes=KRW'),
      headers: {"Accept": "application/json"});

  void update() async {
    var response = await _fetchMarketDate();
    if (response.statusCode == 200) {
      var jsonString = json.decode(response.body);
      // print(jsonString);
      updateFromJson(jsonString);
    }
  }
}
