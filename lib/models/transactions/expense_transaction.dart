import 'dart:convert';

import 'package:contacts_service/contacts_service.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:radency_internship_project_2/models/transactions/transaction.dart';

part 'expense_transaction.g.dart';

enum ExpenseCreationType { IMPORT, AI, MANUAL }

@JsonSerializable(nullable: true)
class ExpenseTransaction extends Transaction {
  String id;
  TransactionType transactionType = TransactionType.Expense;
  String category;
  String accountOrigin;
  double amount;
  DateTime date;
  String note;
  String currency;
  String subcurrency;
  double locationLatitude;
  double locationLongitude;
  ExpenseCreationType creationType;
  DateTime creationDate;
  // TODO: investigate and fix saving/reading image byte array when contact has photo
  // @JsonKey(fromJson: contactFromJson, toJson: contactJsonEncode)
  // Contact sharedContact;

  ExpenseTransaction({
    @required this.date,
    @required this.accountOrigin,
    @required this.category,
    @required this.amount,
    @required this.note,
    @required this.currency,
    this.id,
    //this.sharedContact,
    this.subcurrency,
    @required this.locationLatitude,
    @required this.locationLongitude,
    @required this.creationType,
    this.creationDate,
  });

  factory ExpenseTransaction.fromJson(Map<String, dynamic> json, String id) {
    return _$ExpenseTransactionFromJson(json)..id = id;
  }

  Map<String, dynamic> toJson() => _$ExpenseTransactionToJson(this);
}

// String contactJsonEncode(Contact contact) => jsonEncode(contact?.toMap());
//
// Contact contactFromJson(String string) {
//   if (string == null || string == 'null')
//     return null;
//   else
//     return Contact.fromMap(json.decode(string));
// }
