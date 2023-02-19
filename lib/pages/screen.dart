import 'package:expense_tracker_app/components/expense_summary.dart';
import 'package:expense_tracker_app/components/expense_tile.dart';
import 'package:expense_tracker_app/models/expense_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/expense_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final newExpenseNameController = TextEditingController();
  final newExpenseAmountController = TextEditingController();
  @override
  void initState() {
    super.initState();
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  void addNewExpense() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Expense'),
        content: SizedBox(
          height: 100,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: newExpenseNameController,
                decoration: const InputDecoration(hintText: "Expense Name"),
              ),
              Expanded(
                child: TextField(
                  controller: newExpenseAmountController,
                  decoration: const InputDecoration(hintText: "Amount"),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ),
        actions: [
          //Save Btn
          MaterialButton(
            onPressed: save,
            child: const Text('Save'),
          ),
          //Cancel Btn
          MaterialButton(
            onPressed: cancel,
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void deleteExpense(ExpenseItem expense) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }

  void save() {
    if (newExpenseNameController.text.isNotEmpty &&
        newExpenseAmountController.text.isNotEmpty) {
      ExpenseItem newExpense = ExpenseItem(
        name: newExpenseNameController.text,
        amount: newExpenseAmountController.text,
        dateTime: DateTime.now(),
      );
      Provider.of<ExpenseData>(context, listen: false)
          .addNewExpense(newExpense);
    }
    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    newExpenseAmountController.clear();
    newExpenseNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.grey[200],
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: addNewExpense,
          child: const Icon(Icons.add),
        ),
        body: ListView(
          children: [
            ExpenseSummary(startOfWeek: value.startOfWeekDate()),
            const SizedBox(
              height: 20,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: value.getAllExpenseList().length,
              itemBuilder: (context, index) => ExpenseTile(
                name: value.getAllExpenseList()[index].name,
                amount: value.getAllExpenseList()[index].amount,
                dateTime: value.getAllExpenseList()[index].dateTime,
                deleteTapped: ((p0) =>
                    deleteExpense(value.getAllExpenseList()[index])),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
