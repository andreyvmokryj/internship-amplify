import 'package:meta/meta.dart';

class MonthDetails {
  int monthNumber;
  double income;
  double expenses;

  MonthDetails({@required this.monthNumber, @required this.income, @required this.expenses});

  factory MonthDetails.fromSnapshot(String key, Map<dynamic, dynamic> snapshot) {

    print("MonthlySummary.fromSnapshot: key $key snapshot ${snapshot.toString()}");

    return MonthDetails(
      monthNumber: int.tryParse(key),
      income: double.tryParse(snapshot['income'].toString()),
      expenses: double.tryParse(snapshot['expense'].toString()),
    );
  }
}
