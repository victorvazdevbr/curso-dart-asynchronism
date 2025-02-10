import 'dart:io';

import 'package:dart_asynchronism/models/account.dart';
import 'package:dart_asynchronism/services/account_service.dart';
import 'package:uuid/uuid.dart';

class AccountScreen {
  final AccountService _accountService = AccountService();

  void initializeStream() {
    _accountService.streamInfos.listen((event) {
      print(event);
    });
  }

  void runChatBot() async {
    print('Bom dia! Eu sou Lewis, assistente do Banco d\'Ouro!');
    print('Que bom te ter aqui com a gente.\n');

    bool isRunning = true;
    while (isRunning) {
      print('''Como eu posso te ajudar? (Digite o número desejado)
      1 - Ver todas sua contas.
      2 - Adicionar nova conta.
      3 - Sair\n''');

      String? input = stdin.readLineSync();

      if (input != null) {
        switch (input) {
          case '1':
            await _getAllAccounts();
            break;
          case '2':
            await _addAccount();
            break;
          case '3':
            isRunning = false;
            print('Te vejo na próxima.');
            break;
          default:
            print('Não entendi. Tente novamente.');
            break;
        }
      }
    }
  }

  Future<void> _getAllAccounts() async {
    List<Account> listAccounts = await _accountService.getAll();
    print(listAccounts);
  }

  Future<void> _addAccount() async {
    String name = '', lastName = '';
    double balance = 0;

    String? input;

    var uuid = Uuid();

    while (true) {
      print('Insira o nome:');
      input = stdin.readLineSync();

      if (input != null && input.isNotEmpty) {
        name = input;
        break;
      }
    }

    while (true) {
      print('Insira o sobrenome:');
      input = stdin.readLineSync();

      if (input != null && input.isNotEmpty) {
        lastName = input;
        break;
      }
    }

    while (true) {
      print('Insira o valor em conta:');
      input = stdin.readLineSync();

      if (input != null && input.isNotEmpty && double.tryParse(input) != null) {
        balance = double.tryParse(input)!;
        break;
      }
    }

    Account newAccount = Account(
        id: uuid.v1(), name: name, lastName: lastName, balance: balance);

    await _accountService.addAccount(newAccount);
  }

  Future<void> _addExampleAccount() async {
    Account example =
        Account(id: 'ID555', name: 'John', lastName: 'Davisson', balance: 8800);

    await _accountService.addAccount(example);
  }
}
