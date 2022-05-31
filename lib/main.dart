import 'package:coin_tracker/CoinsProvider.dart';
import 'package:coin_tracker/route/AddCoin.dart';
import 'package:coin_tracker/route/Detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<AppendedCoinIds>(create: (_) => AppendedCoinIds())
  ], child: MyApp()));
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '코인트래커',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: '코인트래커'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<AppendedCoinIds>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
          itemCount: _provider.coins.length,
          itemBuilder: (BuildContext context, int index) {
            var key = _provider.coins.keys.elementAt(index);
            var coin = _provider.coins[key];

            List<TextSpan> titleSpans = [];
            titleSpans.add(TextSpan(text: coin!.name));
            if (coin.marketData.percent_change_24h != null) {
              titleSpans.add(TextSpan(text: " ( "));
              titleSpans.add(TextSpan(
                  text:
                      "${coin.marketData.percent_change_24h! > 0 ? "+" : ""}${coin.marketData.percent_change_24h}%",
                  style: TextStyle(
                      color: coin.marketData.percent_change_24h! > 0
                          ? Colors.red
                          : Colors.blue)));
              titleSpans.add(TextSpan(text: " )"));
            }

            return Container(
                child: ListTile(
              title: RichText(
                  text: TextSpan(
                      children: titleSpans,
                      style: DefaultTextStyle.of(context).style)),
              subtitle: Text(
                  "${coin.marketData.price != null ? NumberFormat('###,###,###,###').format((coin.marketData.price)?.round()).replaceAll(' ', '') + "원" : "로드중"}"),
              leading: Image.network(
                  "https://cryptocurrencyliveprices.com/img/${coin!.id}.png"),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailRoute(coin.id))),
              onLongPress: () {
                _provider.removeCoin(coin.id);
              },
            ));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<AppendedCoinIds>().updateEnd();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddCoinRoute()),
          );
        },
        tooltip: '코인추가',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void initState() {
    //localStorage에 저장된 정보 불러오기
    //context.read()<AppendedCoinIds()
  }
}
