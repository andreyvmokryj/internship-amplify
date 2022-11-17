import 'package:json_annotation/json_annotation.dart';
import 'package:radency_internship_project_2/local_models/transactions/transaction.dart';


part 'income_transaction.g.dart';

@JsonSerializable()
class IncomeTransaction extends AppTransaction {
  String? id;
  TransactionType transactionType = TransactionType.Income;
  String category;
  String accountOrigin;
  double amount;
  DateTime date;
  String note;
  String currency;
  String? subcurrency;

  IncomeTransaction({
    this.id ,
    required this.date,
    required this.accountOrigin,
    required this.category,
    required this.amount,
    required this.note,
    required this.currency,
    this.subcurrency,
  }) : super(
    id: id,
    date: date,
    accountOrigin: accountOrigin,
    transactionType: TransactionType.Income,
    amount: amount,
    note: note,
    currency: currency,
    subcurrency: subcurrency,
  );

  factory IncomeTransaction.fromJson(Map<String, dynamic> json, String id) {
    return _$IncomeTransactionFromJson(json)..id = id;
  }

  Map<String, dynamic> toJson() => _$IncomeTransactionToJson(this);
}
