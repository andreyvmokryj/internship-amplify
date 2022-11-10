import 'package:cloud_functions/cloud_functions.dart';
import 'package:meta/meta.dart';
import 'package:radency_internship_project_2/models/transactions/month_details.dart';

const String FUNCTIONS_YEAR_KEY = 'year';
const String FUNCTIONS_NAME_YEAR = 'getYearSummaryByMonths';
const String FUNCTIONS_WEEKS_START_KEY = 'start';
const String FUNCTIONS_WEEKS_END_KEY = 'end';


// Discontinued
class FirebaseFunctionsProvider {
  Future<List<MonthDetails>> getYearSummary({@required int year}) async {
    List<MonthDetails> monthlySummary = [];

    HttpsCallable callable = FirebaseFunctions.instance
        .httpsCallable(FUNCTIONS_NAME_YEAR, options: HttpsCallableOptions(timeout: const Duration(seconds: 5)));

    dynamic response = await callable.call([
      <String, dynamic>{
        FUNCTIONS_YEAR_KEY: year,
      }
    ]);

    Map<dynamic, dynamic> values = response;
    if (values != null) {
      values.forEach((key, value) {
        monthlySummary.add(MonthDetails.fromSnapshot(key, value));
      });
    }

    return monthlySummary;
  }
}
