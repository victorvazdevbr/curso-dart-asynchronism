import 'dart:async';
import 'dart:convert' as convert;

import 'package:dart_asynchronism/api_key.dart';
import 'package:dart_asynchronism/models/account.dart';
import 'package:http/http.dart' as http;

class AccountService {
  final StreamController<String> _streamController = StreamController<String>();
  Stream<String> get streamInfos => _streamController.stream;
  String url = 'https://api.github.com/gists/6d77af408b596ad4eab5da983949fc02';

  Future<List<Account>> getAll() async {
    final http.Response response = await http.get(Uri.parse(url));

    _streamController.add("${DateTime.now()} | Requisição de leitura.");

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

  Future<void> addAccount(Map<String, dynamic> mapAccount) async {
    List<dynamic> listAccounts = await getAll();

    listAccounts.add(mapAccount);
    String content = convert.jsonEncode(listAccounts);

    http.Response response = await http.post(
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
          "${DateTime.now()} | Requisição de adição bem sucedida (${mapAccount["name"]}).");
    } else {
      _streamController.add(
          "${DateTime.now()} | Requisição falhou (${mapAccount["name"]}).");
    }
  }
}
