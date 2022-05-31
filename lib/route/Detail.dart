import 'package:coin_tracker/domain/DetailCoin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../CoinsProvider.dart';

class DetailRoute extends StatefulWidget {
  final String coinId;
  DetailRoute(this.coinId);
  @override
  State<StatefulWidget> createState() => _DetailState();
}

class _DetailState extends State<DetailRoute> {
  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<AppendedCoinIds>(context, listen: true);
    // TODO: implement build
    var coin = _provider.coins[widget.coinId];
    return Scaffold(
        appBar: AppBar(
          title: Text("${coin!.name}"),
        ),
        body: Center(
          child: Text("${coin!.description}"),
        ));
  }
}
