// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransferTransaction _$TransferTransactionFromJson(Map<String, dynamic> json) =>
    TransferTransaction(
      id: json['id'] as String?,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      note: json['note'] as String,
      fees: (json['fees'] as num).toDouble(),
      accountOrigin: json['accountOrigin'] as String,
      accountDestination: json['accountDestination'] as String,
      currency: json['currency'] as String,
      subcurrency: json['subcurrency'] as String?,
    )..transactionType =
        $enumDecode(_$TransactionTypeEnumMap, json['transactionType']);

Map<String, dynamic> _$TransferTransactionToJson(
        TransferTransaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'transactionType': _$TransactionTypeEnumMap[instance.transactionType]!,
      'accountOrigin': instance.accountOrigin,
      'accountDestination': instance.accountDestination,
      'amount': instance.amount,
      'date': instance.date.toIso8601String(),
      'note': instance.note,
      'currency': instance.currency,
      'subcurrency': instance.subcurrency,
      'fees': instance.fees,
    };

const _$TransactionTypeEnumMap = {
  TransactionType.Income: 'Income',
  TransactionType.Expense: 'Expense',
  TransactionType.Transfer: 'Transfer',
};
