import 'package:meta/meta.dart';
import 'package:radency_internship_project_2/models/transactions/transaction.dart';

class CalendarDay {
  DateTime dateTime;
  String displayedDate;
  bool isActive;
  double incomeAmount;
  double expensesAmount;
  double transferAmount;
  List<AppTransaction> transactions;

  CalendarDay({
    @required this.displayedDate,
    @required this.dateTime,
    @required this.isActive,
    @required this.transactions,
    this.transferAmount,
    this.incomeAmount,
    this.expensesAmount,
  });
}
