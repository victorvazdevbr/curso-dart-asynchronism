import 'dart:convert';

class Account {
  String id;
  String name;
  String lastName;
  double balance;
  String? accountType;

  Account({
    required this.id,
    required this.name,
    required this.lastName,
    required this.balance,
    required this.accountType,
  });

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'] as String,
      name: map['name'] as String,
      lastName: map['lastName'] as String,
      balance: (map['balance'] as num).toDouble(),
      accountType:
          map['accountType'] != null ? map['accountType'] as String : null,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'lastName': lastName,
      'balance': balance,
      'accountType': accountType,
    };
  }

  @override
  String toString() {
    return '\nID: $id\n$name $lastName\nSaldo: $balance\n';
  }

  @override
  bool operator ==(covariant Account other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.lastName == lastName &&
        other.balance == balance;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ lastName.hashCode ^ balance.hashCode;
  }

  Account copyWith({
    String? id,
    String? name,
    String? lastName,
    double? balance,
    String? accountType,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      balance: balance ?? this.balance,
      accountType: accountType ?? this.accountType,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory Account.fromJson(String source) =>
      Account.fromMap(jsonDecode(source));

  double getBalance() {
    return balance;
  }

  void sendTransaction(double amount) {
    balance -= amount;
  }

  void receiveTransaction(double amount) {
    balance += amount;
  }

  // factory Account.fromJson(Map<String, dynamic> json) {
  //   return Account(
  //       id: json['id'] as String,
  //       name: json['name'] as String,
  //       lastName: json['lastName'] as String,
  //       balance: (json['balance'] as num).toDouble());
  // }
}
