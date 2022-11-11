// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpenseTransaction _$ExpenseTransactionFromJson(Map<String, dynamic> json) =>
    ExpenseTransaction(
      date: DateTime.parse(json['date'] as String),
      accountOrigin: json['accountOrigin'] as String,
      category: json['category'] as String,
      amount: (json['amount'] as num).toDouble(),
      note: json['note'] as String,
      currency: json['currency'] as String,
      id: json['id'] as String?,
      subcurrency: json['subcurrency'] as String?,
      locationLatitude: (json['locationLatitude'] as num?)?.toDouble(),
      locationLongitude: (json['locationLongitude'] as num?)?.toDouble(),
      creationType:
          $enumDecode(_$ExpenseCreationTypeEnumMap, json['creationType']),
    )..transactionType =
        $enumDecode(_$TransactionTypeEnumMap, json['transactionType']);

Map<String, dynamic> _$ExpenseTransactionToJson(ExpenseTransaction instance) =>
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
      'locationLatitude': instance.locationLatitude,
      'locationLongitude': instance.locationLongitude,
      'creationType': _$ExpenseCreationTypeEnumMap[instance.creationType]!,
    };

const _$ExpenseCreationTypeEnumMap = {
  ExpenseCreationType.IMPORT: 'IMPORT',
  ExpenseCreationType.AI: 'AI',
  ExpenseCreationType.MANUAL: 'MANUAL',
};

const _$TransactionTypeEnumMap = {
  TransactionType.Income: 'Income',
  TransactionType.Expense: 'Expense',
  TransactionType.Transfer: 'Transfer',
};
