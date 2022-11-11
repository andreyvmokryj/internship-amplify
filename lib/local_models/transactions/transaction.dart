
// flutter packages pub run build_runner build --delete-conflicting-outputs

abstract class AppTransaction {
  String? id;
  TransactionType transactionType;
  DateTime date;
  String accountOrigin;
  double amount;
  String note;
  String currency;
  String? subcurrency;

  AppTransaction({
    required this.date,
    required this.accountOrigin,
    required this.transactionType,
    required this.amount,
    required this.note,
    required this.currency,
    this.id,
    //this.sharedContact,
    this.subcurrency,
  });
}

// ignore: non_constant_identifier_names
final String TYPE_KEY = 'transactionType';
// ignore: non_constant_identifier_names
final String DATE_KEY = 'date';

enum TransactionType {Income, Expense, Transfer}