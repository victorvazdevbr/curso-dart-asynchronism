import 'dart:convert';

class Account {
  String id;
  String name;
  String lastName;
  double balance;

  Account({
    required this.id,
    required this.name,
    required this.lastName,
    required this.balance,
  });

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
        id: map['id'] as String,
        name: map['name'] as String,
        lastName: map['lastName'] as String,
        balance: (map['balance'] as num).toDouble());
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'lastName': lastName,
      'balance': balance,
    };
  }

  @override
  String toString() {
    return '\\nConta $id\\n$name $lastName\\nSaldo: $balance\\n';
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

  String toJson() => jsonEncode(toMap());

  factory Account.fromJson(String source) =>
      Account.fromMap(jsonDecode(source));

  // factory Account.fromJson(Map<String, dynamic> json) {
  //   return Account(
  //       id: json['id'] as String,
  //       name: json['name'] as String,
  //       lastName: json['lastName'] as String,
  //       balance: (json['balance'] as num).toDouble());
  // }
}
