import 'dart:async';

import 'package:dart_asynchronism/api_key.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

StreamController<String> streamController = StreamController<String>();

void main() {
  StreamSubscription streamSubscription = streamController.stream.listen(
    (String info) {
      print(info);
    },
  );

  requestDataAsync();
  sendDataAsync({
    'id': 'NEW002',
    'name': 'flutter2',
    'lastName': 'Dart2',
    'balance': 7000,
  });
}

void requestData() {
  String url =
      'https://gist.githubusercontent.com/victorvazdevbr/6d77af408b596ad4eab5da983949fc02/raw/f587f8cadfadea10030bebbdc19fd4ca6bc2cce0/accounts.json';

  Future<http.Response> futureResponse = http.get(Uri.parse(url));

  futureResponse.then(
    (http.Response response) {
      streamController
          .add("${DateTime.now()} | Requisição de leitura (usando then).");
    },
  );
}

Future<List<dynamic>> requestDataAsync() async {
  String url =
      'https://gist.githubusercontent.com/victorvazdevbr/6d77af408b596ad4eab5da983949fc02/raw/f587f8cadfadea10030bebbdc19fd4ca6bc2cce0/accounts.json';

  final http.Response response = await http.get(Uri.parse(url));

  streamController.add("${DateTime.now()} | Requisição de leitura.");

  return convert.jsonDecode(response.body);
}

Future<void> sendDataAsync(Map<String, dynamic> mapAccount) async {
  List<dynamic> listAccounts = await requestDataAsync();

  listAccounts.add(mapAccount);
  String content = convert.jsonEncode(listAccounts);

  String url = 'https://api.github.com/gists/6d77af408b596ad4eab5da983949fc02';

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
    streamController.add(
        "${DateTime.now()} | Requisição de adição bem sucedida (${mapAccount["name"]}).");
  } else {
    streamController
        .add("${DateTime.now()} | Requisição falhou (${mapAccount["name"]}).");
  }
}
