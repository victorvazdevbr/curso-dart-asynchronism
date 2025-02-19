import 'dart:async';
import 'dart:convert' as convert;

import 'package:dart_asynchronism/api_key.dart';
import 'package:dart_asynchronism/models/account.dart';
import 'package:dio/dio.dart';

class AccountService {
  final StreamController<String> _streamController = StreamController<String>();
  Stream<String> get streamInfos => _streamController.stream;

  final dio = Dio();

  String url = 'https://api.github.com/gists/6d77af408b596ad4eab5da983949fc02';

  Future<List<Account>> getAllDio() async {
    final response = await dio.get(url);

    List<dynamic> listDynamic =
        convert.jsonDecode(response.data['files']['accounts.json']['content']);

    List<Account> listAccounts = [];

    for (dynamic dyn in listDynamic) {
      Map<String, dynamic> mapAccount = dyn as Map<String, dynamic>;
      Account account = Account.fromMap(mapAccount);
      listAccounts.add(account);
    }

    return listAccounts;
  }

  Future<void> addAccountDio(Account account) async {
    Response response;
    List<Account> listAccounts = await getAllDio();
    listAccounts.add(account);

    List<Map<String, dynamic>> listContent = [];
    for (Account account in listAccounts) {
      listContent.add(account.toMap());
    }

    String content = convert.jsonEncode(listContent);

    response = await dio.post(url,
        data: convert.jsonEncode({
          'description': 'accounts.json',
          'public': true,
          'files': {
            'accounts.json': {
              'content': content,
            }
          }
        }),
        options: Options(headers: {'Authorization': 'Bearer $githubApiKey'}));

    if (response.statusCode.toString()[0] == "2") {
      _streamController.add(
          '${DateTime.now()} | Requisição de adição bem sucedida (${account.name}).');
    } else {
      _streamController
          .add('${DateTime.now()} | Requisição falhou (${account.name}).');
    }
  }
}
