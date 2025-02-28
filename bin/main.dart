import 'package:dart_asynchronism/screens/account_screen.dart';

void main() async {
  AccountScreen accountScreen = AccountScreen();
  accountScreen.initializeStream();
  accountScreen.runChatBot();
}
