import 'package:dart_asynchronism/api_key.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

void main() {
  // print('Hello, World!');
  // requestDataAsync();
  sendDataAsync({
    'id': 'NEW001',
    'name': 'flutter',
    'lastName': 'Dart',
    'balance': 5000,
  });
}

void requestData() {
  String url =
      'https://gist.githubusercontent.com/victorvazlabs/6d77af408b596ad4eab5da983949fc02/raw/f587f8cadfadea10030bebbdc19fd4ca6bc2cce0/accounts.json';

  Future<http.Response> futureResponse = http.get(Uri.parse(url));

  print(futureResponse);
  futureResponse.then(
    (http.Response response) {
      print(response.statusCode);
      print(response.body);

      List<dynamic> listAccounts = convert.json.decode(response.body);

      Map<String, dynamic> mapCarla = listAccounts.firstWhere(
        (element) => element["name"] == "Carla",
      );
      print(mapCarla["balance"]);
    },
  );

  print('Última coisa a acontecer na função.');
}

Future<List<dynamic>> requestDataAsync() async {
  String url =
      'https://gist.githubusercontent.com/victorvazlabs/6d77af408b596ad4eab5da983949fc02/raw/f587f8cadfadea10030bebbdc19fd4ca6bc2cce0/accounts.json';

  final http.Response response = await http.get(Uri.parse(url));

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
  print(response.statusCode);
}
