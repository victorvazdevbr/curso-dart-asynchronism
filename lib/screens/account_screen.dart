import 'dart:io';

import 'package:dart_asynchronism/helpers/verify_input.dart';
import 'package:dart_asynchronism/models/account.dart';
import 'package:dart_asynchronism/models/transaction.dart';
import 'package:dart_asynchronism/services/account_service.dart';
import 'package:dart_asynchronism/services/transaction_service.dart';
import 'package:http/http.dart';
import 'package:uuid/uuid.dart';

class AccountScreen {
  final AccountService _accountService = AccountService();
  final TransactionService _transactionService = TransactionService();

  void initializeStream() {
    _accountService.streamInfos.listen((event) {
      print(event);
    });
  }

  Future<void> runChatBot() async {
    print('Bom dia! Eu sou Lewis, assistente do Banco d\'Ouro!');
    print('Que bom te ter aqui com a gente.\n');

    bool isRunning = true;
    while (isRunning) {
      print('''Como eu posso te ajudar? (Digite o número desejado)
      1 - Ver todas sua contas.
      2 - Adicionar nova conta.
      3 - Executar uma transação.
      4 - Obter histório de transações.
      5 - Sair\n''');

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
            await _makeTransaction();
            break;
          case '4':
            await _getAllTransactions();
            break;
          case '5':
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
    try {
      List<Account> listAccounts = await _accountService.getAll();
      print(listAccounts);
    } on ClientException catch (clientException) {
      print('Não foi possível alcançar o servidor.');
      print('Tente novamente mais tarde.');
      print(clientException.message);
      print(clientException.uri);
    } on FormatException catch (e) {
      print('O formato de dados não é válido.');
      print(e.message);
    } on Exception {
      print('Não consegui recuperar os dados da conta.');
      print('Tente novamente mais tarde.');
    } finally {
      print('${DateTime.now()} | Ocorreu uma tentativa de consulta.');
    }
  }

  Future<void> _addAccount() async {
    String name = '', lastName = '', accountType = 'Brigadeiro';
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
        id: uuid.v1(),
        name: name,
        lastName: lastName,
        balance: balance,
        accountType: accountType);

    try {
      await _accountService.addAccount(newAccount);
    } on Exception {
      print('Ocorreu um problema ao tentar adicionar.');
    }
  }

  Future<void> _makeTransaction() async {
    double? amount;
    String? idSender, idReceiver;
    String? input;

    while (true) {
      print('Informe o ID do remetente:');
      input = stdin.readLineSync();

      idSender = verifyInput(input);

      if (idSender != null) break;
    }

    while (true) {
      print('Inform o ID do destinatário:');
      input = stdin.readLineSync();

      idReceiver = verifyInput(input);

      if (idReceiver != null) break;
    }

    while (true) {
      print('Informe a quantidade a ser enviada:');
      input = stdin.readLineSync();

      amount = verifyNumber(input, to: 'double');

      if (amount != null) break;
    }

    await _transactionService.makeTransaction(
      idSender: idSender,
      idReceiver: idReceiver,
      amount: amount,
    );
  }

  Future<void> _getAllTransactions() async {
    try {
      List<Transaction> listTransactions = await _transactionService.getAll();
      print(listTransactions);
    } on Exception catch (e) {
      print('Erro: Não foi possível exibir o histório de transações.');
      print(e);
    }
  }
}
