import 'package:dart_asynchronism/exceptions/transaction_exceptions.dart';
import 'package:dart_asynchronism/screens/account_screen.dart';
import 'package:dart_asynchronism/services/transaction_service.dart';

void main() {
  try {
    TransactionService().makeTransaction(
      idSender: "ID001",
      idReceiver: "ID003",
      amount: 50000,
    );
  } on InsufficientBalanceException catch (e) {
    print(e.message);
    print(
        '${e.cause.name} possui saldo ${e.cause.getBalance()} que é menor que ${e.amount + e.taxes}');
  }
  // AccountScreen accountScreen = AccountScreen();
  // accountScreen.initializeStream();
  // accountScreen.runChatBot();
}

// void main() {
//   print('Começou a main.');
//   function01();
//   print('Finalizou a main.');
// }

// void function01() {
//   print('Começou a Função 01.');
//   function02();
//   print('Finalizou a Função 01.');
// }

// void function02() {
//   print('Começou a Função 02.');
//   for (int i = 0; i <= 5; i++) {
//     print(i);
//   }
//   print('Finalizou a Função 02.');
// }
