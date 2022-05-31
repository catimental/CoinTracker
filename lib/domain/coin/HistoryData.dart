import 'package:http/http.dart' as http;

class History {
  Future<http.Response> _fetchHistoryData() {
    return http.get(
        Uri.parse(
            'https://api.coinpaprika.com/v1/coins/${_detailCoin.id}/ohlcv/historical?start='),
        headers: {"Accept": "application/json"});
  }
}
