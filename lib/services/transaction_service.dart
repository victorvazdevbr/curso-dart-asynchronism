import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dart_asynchronism/api_key.dart';
import 'package:dart_asynchronism/exceptions/transaction_exceptions.dart';
import 'package:dart_asynchronism/helpers/helper_taxes.dart';
import 'package:dart_asynchronism/models/account.dart';
import 'package:dart_asynchronism/models/transaction.dart';
import 'package:dart_asynchronism/services/account_service.dart';
import 'package:http/http.dart';
import 'package:uuid/uuid.dart';

class TransactionService {
  final AccountService _accountService = AccountService();

  String url = 'https://api.github.com/gists/6d77af408b596ad4eab5da983949fc02';

  Future<void> makeTransaction({
    required String idSender,
    required String idReceiver,
    required double amount,
  }) async {
    List<Account> listAccounts = await _accountService.getAll();

    Account? senderAccount = listAccounts.firstWhereOrNull(
      (acc) => acc.id == idSender,
    );
    Account? receiverAccount = listAccounts.firstWhereOrNull(
      (acc) => acc.id == idReceiver,
    );

    if (senderAccount == null) throw SenderNotExistsException();

    if (receiverAccount == null) throw ReceiverNotExistsException();

    double taxes = calculateTaxesByAccount(senderAccount, amount);
    double taxedAmount = amount + taxes;

    if (senderAccount.getBalance() < taxedAmount) {
      throw InsufficientBalanceException(
        cause: senderAccount,
        amount: amount,
        taxes: taxes,
      );
    }

    senderAccount.sendTransaction(taxedAmount);
    receiverAccount.receiveTransaction(amount);

    listAccounts[listAccounts.indexWhere(
      (acc) => acc.id == senderAccount.id,
    )] = senderAccount;

    listAccounts[listAccounts.indexWhere(
      (acc) => acc.id == receiverAccount.id,
    )] = receiverAccount;

    Transaction transaction = Transaction(
      id: Uuid().v1(),
      senderAccountId: idSender,
      receiverAccountId: idReceiver,
      date: DateTime.now(),
      amount: amount,
      taxes: taxes,
    );

    await _accountService.save(listAccounts);
    await addTransaction(transaction);
  }

  Future<List<Transaction>> getAll() async {
    final Response response = await get(Uri.parse(url));
    List<Transaction> listTransaction = [];

    Map<String, dynamic> mapResponse = jsonDecode(response.body);
    List<dynamic> listDynamic =
        jsonDecode(mapResponse['files']['transactions.json']['content']);

    for (dynamic dyn in listDynamic) {
      Map<String, dynamic> mapTransaction = dyn as Map<String, dynamic>;
      Transaction transaction = Transaction.fromMap(mapTransaction);
      listTransaction.add(transaction);
    }

    return listTransaction;
  }

  Future<int> save(List<Transaction> listTransaction,
      {String transactionId = ''}) async {
    List<Map<String, dynamic>> listContent = [];
    for (Transaction transaction in listTransaction) {
      listContent.add(transaction.toMap());
    }

    String content = jsonEncode(listContent);

    final Response response = await post(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $githubApiKey'},
      body: jsonEncode({
        'description': 'accounts.json',
        'public': true,
        'files': {
          'transactions.json': {
            'content': content,
          }
        }
      }),
    );

    return response.statusCode;
  }

  Future<void> addTransaction(Transaction transaction) async {
    List<Transaction> listTransactions = await getAll();
    listTransactions.add(transaction);

    int statusCode =
        await save(listTransactions, transactionId: transaction.id);

    if (statusCode.toString()[0] == "2") {
      print(
          '${DateTime.now()} | Requisição de adição bem sucedida (${transaction.id}).');
    } else {
      print('${DateTime.now()} | Requisição falhou (${transaction.id}).');
    }
  }
}
