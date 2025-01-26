import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

void main() {
  // print('Hello, World!');
  requestDataAsync();
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

Future<void> requestDataAsync() async {
  String url =
      'https://gist.githubusercontent.com/victorvazlabs/6d77af408b596ad4eab5da983949fc02/raw/f587f8cadfadea10030bebbdc19fd4ca6bc2cce0/accounts.json';

  http.Response response = await http.get(Uri.parse(url));

  print(convert.jsonDecode(response.body)[0]);

  print('De fato a última coisa vai acontecer na funcão.');
}
