import 'package:http/http.dart' as http;

class HistoryData {
  late int updatedMilliseconds;
  late double close;
  late double open;
  late double high;
  late double low;
  late int volume;
  late DateTime time_open;
  HistoryData.fromJson(Map<String, dynamic> json) {
    updatedMilliseconds = DateTime.now().millisecondsSinceEpoch;
    close = json['close'];
    time_open = DateTime.parse(json['time_open']);
    open = json['open'];
    high = json['high'];
    low = json['low'];
    volume = json['volume'];
  }
}
