class ForexFetchPriceModel {
  final String? symbol;
  final String? open;
  final String? high;
  final String? low;
  final String? close;

  const ForexFetchPriceModel({
    required this.symbol,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });

  factory ForexFetchPriceModel.fromJson(Map<String, dynamic> json) {
    return ForexFetchPriceModel(
      symbol: json['s'],
      open: json['o'],
      high: json['h'],
      low: json['l'],
      close: json['c'],
    );
  }
}
