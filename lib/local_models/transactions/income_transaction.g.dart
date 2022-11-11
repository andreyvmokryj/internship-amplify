// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IncomeTransaction _$IncomeTransactionFromJson(Map<String, dynamic> json) =>
    IncomeTransaction(
      id: json['id'] as String?,
      date: DateTime.parse(json['date'] as String),
      accountOrigin: json['accountOrigin'] as String,
      category: json['category'] as String,
      amount: (json['amount'] as num).toDouble(),
      note: json['note'] as String,
      currency: json['currency'] as String,
      subcurrency: json['subcurrency'] as String?,
    )..transactionType =
        $enumDecode(_$TransactionTypeEnumMap, json['transactionType']);

Map<String, dynamic> _$IncomeTransactionToJson(IncomeTransaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'transactionType': _$TransactionTypeEnumMap[instance.transactionType]!,
      'category': instance.category,
      'accountOrigin': instance.accountOrigin,
      'amount': instance.amount,
      'date': instance.date.toIso8601String(),
      'note': instance.note,
      'currency': instance.currency,
      'subcurrency': instance.subcurrency,
    };

const _$TransactionTypeEnumMap = {
  TransactionType.Income: 'Income',
  TransactionType.Expense: 'Expense',
  TransactionType.Transfer: 'Transfer',
};
