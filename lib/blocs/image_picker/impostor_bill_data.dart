import 'package:radency_internship_project_2/blocs/transactions/add_transaction/temp_values.dart';
import 'package:radency_internship_project_2/local_models/transactions/expense_transaction.dart';
import 'package:radency_internship_project_2/local_models/transactions/transaction.dart';

List<AppTransaction> impostorTransactions = [
  ExpenseTransaction(
      date: DateTime.now(),
      accountOrigin: TempTransactionsValues().accounts[0],
      category: TempTransactionsValues().expenseCategories[0],
      amount: 35.40,
      note: 'Pasta Zara Perline',
      currency: 'UAH',
      locationLatitude: null,
      locationLongitude: null,
      creationType: ExpenseCreationType.AI),
  ExpenseTransaction(
      date: DateTime.now(),
      accountOrigin: TempTransactionsValues().accounts[0],
      category: TempTransactionsValues().expenseCategories[0],
      amount: 33.80,
      note: 'Alpinella Шоколад Coconut',
      currency: 'UAH',
      locationLatitude: null,
      locationLongitude: null,
      creationType: ExpenseCreationType.AI),
  ExpenseTransaction(
      date: DateTime.now(),
      accountOrigin: TempTransactionsValues().accounts[0],
      category: TempTransactionsValues().expenseCategories[0],
      amount: 75.00,
      note: 'Корона Шоколад Max Fun',
      currency: 'UAH',
      locationLatitude: null,
      locationLongitude: null,
      creationType: ExpenseCreationType.AI),
];
