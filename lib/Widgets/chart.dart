// ignore: file_names
// ignore_for_file: avoid_print, prefer_const_constructors, file_names

import 'package:expense_planner/Models/Transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Models/Transaction.dart';
import 'chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransaction;
  // ignore: use_key_in_widget_constructors, prefer_const_constructors_in_immutables
  const Chart(this.recentTransaction);
  List<Map<String, dynamic>> get groupedTransactionValues {
    // Seven Week days
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0.0;

      for (var i = 0; i < recentTransaction.length; i++) {
        if (recentTransaction[i].date.day == weekDay.day &&
            recentTransaction[i].date.month == weekDay.month &&
            recentTransaction[i].date.year == weekDay.year) {
          totalSum += recentTransaction[i].amount;
        }
      }
      // print(totalSum);
      // amount -> all transaction that happened in this day.
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum
      };
    }).reversed.toList();
  }

  double get totalSpending {
    // fold : Allows us to change a list to another type.
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((data) {
            return Flexible(
              // force it into its assign width.
              fit: FlexFit.tight,
              child: ChartBar(
                  data['day'].toString(),
                  data['amount'],
                  totalSpending == 0.0
                      ? 0.0
                      : (data['amount'] as double) / totalSpending),
            );
          }).toList(),
        ),
      ),
    );
  }
}
