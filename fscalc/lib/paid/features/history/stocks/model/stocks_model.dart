import 'dart:convert';

class StocksModel {
  DateTime entryDate;
  DateTime exitDate;
  String tickerSymbol;
  String bookValue;
  String marketValue;
  String entryPrice;
  String exitPrice;
  String result;

  StocksModel({
    required this.entryDate,
    required this.exitDate,
    required this.tickerSymbol,
    required this.bookValue,
    required this.marketValue,
    required this.entryPrice,
    required this.exitPrice,
    required this.result,
  });

  Map<String, dynamic> toMap() {
    return {
      'entryDate': entryDate.millisecondsSinceEpoch,
      'exitDate': exitDate.millisecondsSinceEpoch,
      'tickerSymbol': tickerSymbol,
      'bookValue': bookValue,
      'marketValue': marketValue,
      'entryPrice': entryPrice,
      'exitPrice': exitPrice,
      'result': result,
    };
  }

  factory StocksModel.fromMap(Map<String, dynamic> map) {
    return StocksModel(
      entryDate: DateTime.fromMillisecondsSinceEpoch(map['entryDate']),
      exitDate: DateTime.fromMillisecondsSinceEpoch(map['exitDate']),
      tickerSymbol: map['tickerSymbol'] ?? '',
      bookValue: map['bookValue'] ?? '',
      marketValue: map['marketValue'] ?? '',
      entryPrice: map['entryPrice'] ?? '',
      exitPrice: map['exitPrice'] ?? '',
      result: map['result'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory StocksModel.fromJson(String source) =>
      StocksModel.fromMap(json.decode(source));
}
