import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ForexModel {
  DateTime entryDate;
  DateTime exitDate;
  String currencyPair;
  String bookValue;
  String marketValue;
  // String entryPrice;
  // String exitPrice;
  String result;

  ForexModel({
    required this.entryDate,
    required this.exitDate,
    required this.currencyPair,
    required this.bookValue,
    required this.marketValue,
    required this.result,
  });

  static fromSnapshot(QueryDocumentSnapshot<Object?> e) {}

  Map<String, dynamic> toMap() {
    return {
      'entryDate': entryDate.millisecondsSinceEpoch,
      'exitDate': exitDate.millisecondsSinceEpoch,
      'currencyPair': currencyPair,
      'bookValue': bookValue,
      'marketValue': marketValue,
      'result': result,
    };
  }

  factory ForexModel.fromMap(Map<String, dynamic> map) {
    return ForexModel(
      entryDate: DateTime.fromMillisecondsSinceEpoch(map['entryDate']),
      exitDate: DateTime.fromMillisecondsSinceEpoch(map['exitDate']),
      currencyPair: map['currencyPair'] ?? '',
      bookValue: map['bookValue'] ?? '',
      marketValue: map['marketValue'] ?? '',
      result: map['result'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ForexModel.fromJson(String source) =>
      ForexModel.fromMap(json.decode(source));
}
