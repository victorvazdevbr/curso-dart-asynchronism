import 'dart:async';
import 'dart:convert' as convert;

import 'package:dart_asynchronism/api_key.dart';
import 'package:dart_asynchronism/models/account.dart';
import 'package:http/http.dart' as http;

class AccountService {
  final StreamController<String> _streamController = StreamController<String>();
  Stream<String> get streamInfos => _streamController.stream;

  String url =
      'https://api.github.com.br/gists/6d77af408b596ad4eab5da983949fc02';

  Future<List<Account>> getAll() async {
    final http.Response response = await http.get(Uri.parse(url));

    _streamController.add('${DateTime.now()} | Requisição de leitura.');

    Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);
    List<dynamic> listDynamic =
        convert.jsonDecode(mapResponse['files']['accounts.json']['content']);

    List<Account> listAccounts = [];

    for (dynamic dyn in listDynamic) {
      Map<String, dynamic> mapAccount = dyn as Map<String, dynamic>;
      Account account = Account.fromMap(mapAccount);
      listAccounts.add(account);
    }

    return listAccounts;
  }

  Future<void> addAccount(Account account) async {
    List<Account> listAccounts = await getAll();
    listAccounts.add(account);

    List<Map<String, dynamic>> listContent = [];
    for (Account account in listAccounts) {
      listContent.add(account.toMap());
    }

    String content = convert.jsonEncode(listContent);

    final http.Response response = await http.post(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $githubApiKey'},
      body: convert.jsonEncode({
        'description': 'accounts.json',
        'public': true,
        'files': {
          'accounts.json': {
            'content': content,
          }
        }
      }),
    );

    if (response.statusCode.toString()[0] == "2") {
      _streamController.add(
          '${DateTime.now()} | Requisição de adição bem sucedida (${account.name}).');
    } else {
      _streamController
          .add('${DateTime.now()} | Requisição falhou (${account.name}).');
    }
  }

  Future<Account> getAccountById(String id) async {
    List<Account> listAccounts = await getAll();
    List<Map<String, dynamic>> listMapAccounts =
        listAccounts.map((account) => account.toMap()).toList();

    Map<String, dynamic> accountMap = listMapAccounts.firstWhere(
        (element) => element['id'] == id,
        orElse: () =>
            throw Exception('Conta com o id $id não foi encontrada.'));

    return Account.fromMap(accountMap);
  }

  Future<void> updateAccount(Account account) async {
    List<Account> listAccounts = await getAll();

    int index = listAccounts.indexWhere((a) => a.id == account.id);

    if (index == -1) {
      throw Exception('Conta com ID ${account.id} não encontrada.');
    }

    listAccounts[index] = account;

    List<Map<String, dynamic>> listMapAccounts =
        listAccounts.map((account) => account.toMap()).toList();

    String content = convert.jsonEncode(listMapAccounts);

    http.Response response = await http.patch(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $githubApiKey'},
      body: convert.jsonEncode({
        'description': 'accounts.json',
        'public': true,
        'files': {
          'accounts.json': {
            'content': content,
          }
        }
      }),
    );

    if (response.statusCode.toString()[0] == "2") {
      _streamController.add(
          "${DateTime.now()} | Requisição de atualização bem sucedida (${account.name}).");
    } else {
      _streamController.add(
          "${DateTime.now()} | Requisição de atualização falhou (${account.name}).");
    }
  }

  Future<void> deleteAccount(Account account) async {
    List<Account> listAccounts = await getAll();

    int index = listAccounts.indexWhere((a) => a.id == account.id);

    if (index == -1) {
      throw Exception('Conta com ID ${account.id} não encontrada.');
    }

    listAccounts.remove(account);

    List<Map<String, dynamic>> listMapAccounts =
        listAccounts.map((account) => account.toMap()).toList();

    String content = convert.jsonEncode(listMapAccounts);

    http.Response response = await http.patch(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $githubApiKey'},
      body: convert.jsonEncode({
        'description': 'accounts.json',
        'public': true,
        'files': {
          'accounts.json': {
            'content': content,
          }
        }
      }),
    );

    if (response.statusCode.toString()[0] == "2") {
      _streamController.add(
          "${DateTime.now()} | Requisição de remoção bem sucedida (${account.name}).");
    } else {
      _streamController.add(
          "${DateTime.now()} | Requisição de remoção falhou (${account.name}).");
    }
  }
}
