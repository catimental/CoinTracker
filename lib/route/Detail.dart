import 'dart:async';
import 'dart:convert';

import 'package:coin_tracker/domain/DetailCoin.dart';
import 'package:coin_tracker/util/StringFormatUtils.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import '../CoinsProvider.dart';

import '../domain/coin/HistoryData.dart';

class DetailRoute extends StatefulWidget {
  final String coinId;

  DetailRoute(this.coinId, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DetailState();
}

class _DetailState extends State<DetailRoute> {
  late StreamController _historiesController;

  Future<http.Response> _responseHistoryData() {
    final int endMilliSeconds =
        (DateTime.now().millisecondsSinceEpoch / 1000).floor();
    final int startMilliSeconds =
        endMilliSeconds - 60 * 60 * 24 * 6; // 6일 이상의 데이터를 발급받으려면 Key가 필요함 :(
    print(
        'https://api.coinpaprika.com/v1/coins/${widget.coinId}/ohlcv/historical?start=$startMilliSeconds&end=$endMilliSeconds&quotes=KRW');
    return http.get(
        Uri.parse(
            'https://api.coinpaprika.com/v1/coins/${widget.coinId}/ohlcv/historical?start=$startMilliSeconds&end=$endMilliSeconds&quotes=KRW'),
        headers: {"Accept": "application/json"});
  }

  Future _fetchHistoryData() async {
    final response = await _responseHistoryData();
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("fetch error");
    }
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<AppendedCoinIds>(context, listen: true);
    // TODO: implement build
    var coin = _provider.coins[widget.coinId];
    if (coin!.marketData.price != null) {
      //todo must fix this
      return Scaffold(
          appBar: AppBar(
            title: Text("${coin!.name}"),
          ),
          body: Container(
            margin: EdgeInsets.only(top: 20, left: 10, right: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '현재가격: ${StringFormatUtils.formatKRW(coin.marketData.price!)}',
                      textAlign: TextAlign.right,
                    )
                  ],
                ),
                StreamBuilder(
                    stream: _historiesController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<HistoryData> histories = [];
                        for (var historyJson
                            in (snapshot.data as List<dynamic>)) {
                          histories.add(HistoryData.fromJson(historyJson));
                        }
                        return Container(
                          height: 300.0,
                          child: SfCartesianChart(
                              primaryXAxis: CategoryAxis(),
                              title: ChartTitle(text: "차트(달러)"),
                              series: <LineSeries<HistoryData, String>>[
                                LineSeries<HistoryData, String>(
                                    // Bind data source
                                    dataSource: histories,
                                    dataLabelSettings:
                                        DataLabelSettings(isVisible: true),
                                    xValueMapper: (HistoryData history, _) =>
                                        "${history.time_open.month}.${history.time_open.day}",
                                    yValueMapper: (HistoryData history, _) {
                                      return double.parse(history.close
                                          .toStringAsFixed(
                                              history.close >= 1000 ? 2 : 5));
                                    }),
                              ]),
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Text(
                      "설명",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),
                ExpandableText(
                  '${coin.description}',
                  expandText: '더보기',
                  collapseText: '줄이기',
                  maxLines: 1,
                  linkColor: Colors.blue,
                ),
              ],
            ),
          ));
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text("${coin!.name}"),
          ),
          body: Container(
            child: CircularProgressIndicator(),
          ));
    }
  }

  @override
  void initState() {
    super.initState();
    _historiesController = StreamController();
    _fetchHistoryData().then((res) async {
      _historiesController.add(res);
      return res;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
