import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radency_internship_project_2/blocs/settings/settings_bloc.dart';
import 'package:radency_internship_project_2/local_models/transactions/expense_transaction.dart';
import 'package:radency_internship_project_2/local_models/transactions/income_transaction.dart';
import 'package:radency_internship_project_2/local_models/transactions/transaction.dart';
import 'package:radency_internship_project_2/local_models/transactions/transfer_transaction.dart';
import 'package:radency_internship_project_2/utils/date_helper.dart';
import 'package:radency_internship_project_2/utils/strings.dart';
import 'package:radency_internship_project_2/utils/styles.dart';

class TransactionWidget extends StatelessWidget {
  final AppTransaction transaction;

  const TransactionWidget({Key? key, required this.transaction}) : super(key: key);

  Widget build(BuildContext context) {
    String currency = BlocProvider.of<SettingsBloc>(context).state.currency;

    Color? valueColor;
    String subLabel = "";
    String accountLabel = "";

    if (transaction is TransferTransaction) {
      subLabel = "Transfer";
      accountLabel = transaction.accountOrigin + " –> " + (transaction as TransferTransaction).accountDestination;
    }
    if (transaction is ExpenseTransaction) {
      subLabel = (transaction as ExpenseTransaction).category;
      accountLabel = transaction.accountOrigin;
      valueColor = Colors.red;
    }
    if (transaction is IncomeTransaction) {
      accountLabel = transaction.accountOrigin;
      subLabel = (transaction as IncomeTransaction).category;
      valueColor = Colors.blue;
    }

    return Container(
      padding: EdgeInsets.only(
        top: 10,
        bottom: 10,
        left: 10,
        right: 10,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(DateHelper().dateToString(transaction.date)),
                SizedBox(
                  height: 5,
                ),
                Text(subLabel),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              accountLabel,
              style: regularTextStyle,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  "${getCurrencySymbol(currency)} ${getMoneyFormatted(transaction.amount)}",
                  style: regularTextStyle.copyWith(
                    color: valueColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
