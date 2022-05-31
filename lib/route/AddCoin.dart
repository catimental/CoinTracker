import 'dart:convert';
import 'package:coin_tracker/domain/Coin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddCoinRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddCoinState();
}

class _AddCoinState extends State<AddCoinRoute> {
  late Future<List<Coin>> coins;

  Future<http.Response> fetchData() =>
      http.get(Uri.parse('https://api.coinpaprika.com/v1/coins/'),
          headers: {"Accept": "application/json"});

  Future<List<Coin>> updateCoinsData() async {
    List<Coin> _coins = [];
    var response = await fetchData();
    if (response.statusCode == 200) {
      // return Coin.fromJson();

      List<dynamic> coins = json.decode(response.body);
      for (var coin in coins) {
        _coins.add(Coin.fromJson(coin));
      }
    }
    return _coins;
  }

  @override
  void initState() {
    super.initState();
    coins = updateCoinsData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(title: Text("코인 추가")),
        body: FutureBuilder<List<Coin>>(
            future: coins,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return ListView.builder(itemBuilder: (context, index) {
                  return GestureDetector(
                    child: Card(
                      child: Text(snapshot.data![index].name),
                    ),
                    onTap: () => print(index),
                  );
                });
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
