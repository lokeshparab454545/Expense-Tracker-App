import 'package:expense_tracker_app/data/hive_database.dart';
import 'package:expense_tracker_app/dateTime/date_time_helper.dart';
import 'package:expense_tracker_app/models/expense_items.dart';
import 'package:flutter/cupertino.dart';

class ExpenseData extends ChangeNotifier {
  //list of All expenses
  List<ExpenseItem> overallExpenseList = [];

  //get Expense List
  List<ExpenseItem> getAllExpenseList() {
    return overallExpenseList;
  }

  final db = HiveDataBase();
  void prepareData() {
    if (db.readData().isNotEmpty) {
      overallExpenseList = db.readData();
    }
  }

  //Add new Expense
  void addNewExpense(ExpenseItem newExpense) {
    overallExpenseList.add(newExpense);
    notifyListeners();
    db.saveData(overallExpenseList);
  }

  //Delete Expense
  void deleteExpense(ExpenseItem expense) {
    overallExpenseList.remove(expense);
    notifyListeners();
    db.saveData(overallExpenseList);
  }

  //Get weekdays
  String getDayName(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thur';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  DateTime startOfWeekDate() {
    DateTime? startofWeek;
    DateTime today = DateTime.now();
    for (int i = 0; i < 7; i++) {
      if (getDayName(today.subtract(Duration(days: i))) == 'Sun') {
        startofWeek = today.subtract(Duration(days: i));
      }
    }
    return startofWeek!;
  }

  //get the day for the start of the week
  Map<String, double> calDailyExpenseSummary() {
    Map<String, double> dailyExpenseSummary = {};

    for (var expense in overallExpenseList) {
      String date = converDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);
      if (dailyExpenseSummary.containsKey(date)) {
        double currAmnt = dailyExpenseSummary[date]!;
        currAmnt += amount;
        dailyExpenseSummary[date] = currAmnt;
      } else {
        dailyExpenseSummary.addAll({date: amount});
      }
    }
    return dailyExpenseSummary;
  }
}
