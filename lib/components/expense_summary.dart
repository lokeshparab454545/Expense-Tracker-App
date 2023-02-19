import 'package:expense_tracker_app/bar%20graph/bar_graph.dart';
import 'package:expense_tracker_app/data/expense_data.dart';
import 'package:expense_tracker_app/dateTime/date_time_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseSummary extends StatelessWidget {
  final DateTime startOfWeek;
  const ExpenseSummary({super.key, required this.startOfWeek});

  double caclMax(
    ExpenseData value,
    String sunday,
    String monday,
    String tuesday,
    String wednesday,
    String thursday,
    String friday,
    String saturday,
  ) {
    double? max = 100;
    List<double> values = [
      value.calDailyExpenseSummary()[sunday] ?? 0,
      value.calDailyExpenseSummary()[monday] ?? 0,
      value.calDailyExpenseSummary()[tuesday] ?? 0,
      value.calDailyExpenseSummary()[wednesday] ?? 0,
      value.calDailyExpenseSummary()[thursday] ?? 0,
      value.calDailyExpenseSummary()[friday] ?? 0,
      value.calDailyExpenseSummary()[saturday] ?? 0,
    ];

    values.sort();
    max = values.last * 1.1;
    return max == 0 ? 100 : max;
  }

  String calWeekTotal(
    ExpenseData value,
    String sunday,
    String monday,
    String tuesday,
    String wednesday,
    String thursday,
    String friday,
    String saturday,
  ) {
    List<double> values = [
      value.calDailyExpenseSummary()[sunday] ?? 0,
      value.calDailyExpenseSummary()[monday] ?? 0,
      value.calDailyExpenseSummary()[tuesday] ?? 0,
      value.calDailyExpenseSummary()[wednesday] ?? 0,
      value.calDailyExpenseSummary()[thursday] ?? 0,
      value.calDailyExpenseSummary()[friday] ?? 0,
      value.calDailyExpenseSummary()[saturday] ?? 0,
    ];

    double total = 0;
    for (int i = 0; i < values.length; i++) {
      total += values[i];
    }
    return total.toString();
  }

  @override
  Widget build(BuildContext context) {
    String sunday =
        converDateTimeToString(startOfWeek.add(const Duration(days: 0)));
    String monday =
        converDateTimeToString(startOfWeek.add(const Duration(days: 1)));
    String tuesday =
        converDateTimeToString(startOfWeek.add(const Duration(days: 2)));
    String wednesday =
        converDateTimeToString(startOfWeek.add(const Duration(days: 3)));
    String thursday =
        converDateTimeToString(startOfWeek.add(const Duration(days: 4)));
    String friday =
        converDateTimeToString(startOfWeek.add(const Duration(days: 5)));
    String saturday =
        converDateTimeToString(startOfWeek.add(const Duration(days: 6)));
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                const Text(
                  'Week Total: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Rs.${calWeekTotal(value, sunday, monday, tuesday, wednesday, thursday, friday, saturday)}',
                ),
              ],
            ),
          ),
          SizedBox(
            height: 200,
            child: BarGraph(
              maxY: caclMax(value, sunday, monday, tuesday, wednesday, thursday,
                  friday, saturday),
              sunAmount: value.calDailyExpenseSummary()[sunday] ?? 0,
              monAmount: value.calDailyExpenseSummary()[monday] ?? 0,
              tueAmount: value.calDailyExpenseSummary()[tuesday] ?? 0,
              wedAmount: value.calDailyExpenseSummary()[wednesday] ?? 0,
              thurAmount: value.calDailyExpenseSummary()[thursday] ?? 0,
              friAmount: value.calDailyExpenseSummary()[friday] ?? 0,
              satAmount: value.calDailyExpenseSummary()[saturday] ?? 0,
            ),
          ),
        ],
      ),
    );
  }
}
