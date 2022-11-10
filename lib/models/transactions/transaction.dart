
// flutter packages pub run build_runner build --delete-conflicting-outputs

abstract class Transaction {
  String id;
  TransactionType transactionType;
  DateTime date;
  DateTime creationDate;
  String accountOrigin;
  double amount;
  String note;
  String currency;
  String subcurrency;
}

// ignore: non_constant_identifier_names
final String TYPE_KEY = 'transactionType';
// ignore: non_constant_identifier_names
final String DATE_KEY = 'date';

enum TransactionType {Income, Expense, Transfer}