import 'dart:convert';

class Transaction {
  String id;
  String senderAccountId;
  String receiverAccountId;
  DateTime date;
  double amount;
  double taxes;

  Transaction({
    required this.id,
    required this.senderAccountId,
    required this.receiverAccountId,
    required this.date,
    required this.amount,
    required this.taxes,
  });

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as String,
      senderAccountId: map['senderAccountId'] as String,
      receiverAccountId: map['receiverAccountId'] as String,
      date: DateTime.parse(map['date']),
      amount: (map['amount'] as num).toDouble(),
      taxes: (map['taxes'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'senderAccountId': senderAccountId,
      'receiverAccountId': receiverAccountId,
      'date': date.toIso8601String(),
      'amount': amount,
      'taxes': taxes,
    };
  }

  Transaction copyWith(
    String? id,
    String? senderAccountId,
    String? receiverAccountId,
    DateTime? date,
    double? amount,
    double? taxes,
  ) {
    return Transaction(
      id: id ?? this.id,
      senderAccountId: senderAccountId ?? this.senderAccountId,
      receiverAccountId: receiverAccountId ?? this.receiverAccountId,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      taxes: taxes ?? this.taxes,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory Transaction.fromJson(String source) =>
      Transaction.fromMap(jsonDecode(source));

  @override
  String toString() =>
      'ID: $id\nSender ID: $senderAccountId\nReceiver ID: $receiverAccountId\nDate: $date\nAmount: $amount\nTaxes: $taxes';

  @override
  bool operator ==(covariant Transaction other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.senderAccountId == senderAccountId &&
        other.receiverAccountId == receiverAccountId &&
        other.date == date &&
        other.amount == amount &&
        other.taxes == taxes;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      senderAccountId.hashCode ^
      receiverAccountId.hashCode ^
      date.hashCode ^
      amount.hashCode ^
      taxes.hashCode;
}
