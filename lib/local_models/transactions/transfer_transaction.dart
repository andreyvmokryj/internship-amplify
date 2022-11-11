import 'package:json_annotation/json_annotation.dart';
import 'package:radency_internship_project_2/local_models/transactions/transaction.dart';

part 'transfer_transaction.g.dart';

@JsonSerializable()
class TransferTransaction extends AppTransaction {
  String? id;
  TransactionType transactionType = TransactionType.Transfer;
  String accountOrigin;
  String accountDestination;
  double amount;
  DateTime date;
  String note;
  String currency;
  String? subcurrency;
  double fees;

  TransferTransaction({
    this.id,
    required this.amount,
    required this.date,
    required this.note,
    required this.fees,
    required this.accountOrigin,
    required this.accountDestination,
    required this.currency,
    this.subcurrency,
  }) : super(
    id: id,
    date: date,
    accountOrigin: accountOrigin,
    transactionType: TransactionType.Transfer,
    amount: amount,
    note: note,
    currency: currency,
    subcurrency: subcurrency,
  );

  factory TransferTransaction.fromJson(Map<String, dynamic> json, String id) =>
      _$TransferTransactionFromJson(json)..id = id;

  Map<String, dynamic> toJson() => _$TransferTransactionToJson(this);
}
