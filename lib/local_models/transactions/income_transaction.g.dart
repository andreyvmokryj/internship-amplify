// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IncomeTransaction _$IncomeTransactionFromJson(Map<String, dynamic> json) {
  return IncomeTransaction(
    id: json['id'] as String,
    date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
    accountOrigin: json['accountOrigin'] as String,
    category: json['category'] as String,
    amount: (json['amount'] as num)?.toDouble(),
    note: json['note'] as String,
    currency: json['currency'] as String,
    subcurrency: json['subcurrency'] as String,
    creationDate: json['creationDate'] == null
        ? null
        : DateTime.parse(json['creationDate'] as String),
  )..transactionType =
      _$enumDecodeNullable(_$TransactionTypeEnumMap, json['transactionType']);
}

Map<String, dynamic> _$IncomeTransactionToJson(IncomeTransaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'transactionType': _$TransactionTypeEnumMap[instance.transactionType],
      'category': instance.category,
      'accountOrigin': instance.accountOrigin,
      'amount': instance.amount,
      'date': instance.date?.toIso8601String(),
      'note': instance.note,
      'currency': instance.currency,
      'subcurrency': instance.subcurrency,
      'creationDate': instance.creationDate?.toIso8601String(),
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$TransactionTypeEnumMap = {
  TransactionType.Income: 'Income',
  TransactionType.Expense: 'Expense',
  TransactionType.Transfer: 'Transfer',
};
