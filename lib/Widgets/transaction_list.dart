// ignore: file_names
// ignore_for_file: file_names

import '/Widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Models/Transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function _deleteTransaction;
  TransactionList(this.transactions, this._deleteTransaction);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: [
                Text("No Transactions Added Yet!",
                    style: Theme.of(context).textTheme.subtitle1),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: constraints.maxHeight * 0.15,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                )
              ],
            );
          })
        : ListView(
            children: transactions
                .map((tx) => TransactionItem(
                    key: ValueKey(tx.id),
                    transaction: tx,
                    mediaQuery: mediaQuery,
                    deleteTransaction: _deleteTransaction))
                .toList());
  }
}
