import 'package:dart_asynchronism/services/account_service.dart';

void main() {
  var listAccounts = AccountService().getAll();

  print(listAccounts);
}
