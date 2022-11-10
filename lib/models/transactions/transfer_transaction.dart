import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:radency_internship_project_2/models/transactions/transaction.dart';

part 'transfer_transaction.g.dart';

@JsonSerializable(nullable: true)
class TransferTransaction extends AppTransaction {
  String id;
  TransactionType transactionType = TransactionType.Transfer;
  String accountOrigin;
  String accountDestination;
  double amount;
  DateTime date;
  String note;
  String currency;
  String subcurrency;
  double fees;
  DateTime creationDate;

  TransferTransaction({
    this.id,
    @required this.amount,
    @required this.date,
    @required this.note,
    @required this.fees,
    @required this.accountOrigin,
    @required this.accountDestination,
    @required this.currency,
    this.subcurrency,
    this.creationDate,
  });

  factory TransferTransaction.fromJson(Map<String, dynamic> json, String id) =>
      _$TransferTransactionFromJson(json)..id = id;

  Map<String, dynamic> toJson() => _$TransferTransactionToJson(this);
}
