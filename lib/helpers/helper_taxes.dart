import 'package:dart_asynchronism/models/account.dart';

double calculateTaxesByAccount(Account account, double amount) {
  if (amount < 5000) return 0;

  if (account.accountType != null) {
    switch (account.accountType!.toLowerCase()) {
      case 'ambrosia':
        return 0.005;
      case 'canjica':
        return 0.0033;
      case 'pudim':
        return 0.0025;
      default:
        return 0.0001;
    }
  } else {
    return 0;
  }
}
