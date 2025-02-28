import 'package:dart_asynchronism/models/account.dart';

class SenderNotExistsException implements Exception {
  String message;

  SenderNotExistsException({
    this.message = 'Remetente não encontrado.',
  });
}

class ReceiverNotExistsException implements Exception {
  String message;

  ReceiverNotExistsException({
    this.message = 'Destinatário não encontrado.',
  });
}

class InsufficientBalanceException implements Exception {
  String message; // Mensagem amigável
  Account cause; // Objeto causador da exeção
  double amount; // Informações específicas
  double taxes; // Informações específicas

  InsufficientBalanceException({
    this.message = 'Saldo insuficiente para a transação',
    required this.cause,
    required this.amount,
    required this.taxes,
  });
}
