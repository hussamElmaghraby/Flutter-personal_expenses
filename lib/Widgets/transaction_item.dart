import 'dart:math';

import '../Models/Transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  TransactionItem({
    Key? key,
    required this.transaction,
    required this.mediaQuery,
    required Function deleteTransaction,
  })  : _deleteTransaction = deleteTransaction,
        super(key: key);

  final Transaction transaction;
  final MediaQueryData mediaQuery;
  final Function _deleteTransaction;
  Color? _bgColor;

  @protected
  @mustCallSuper
  void initState() {
    const availableColors = [
      Colors.red,
      Colors.blue,
      Colors.grey,
      Colors.purple
    ];
    _bgColor = availableColors[Random().nextInt(4)];
    print(Random().nextInt(4));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _bgColor,
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: FittedBox(child: Text('\$${transaction.amount}')),
          ),
        ),
        trailing: mediaQuery.size.width > 460
            ? TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.delete),
                label: const Text("Delete"))
            : IconButton(
                icon: const Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () => _deleteTransaction(transaction.id),
              ),
        title: Text(transaction.title,
            style: Theme.of(context).textTheme.subtitle1),
        subtitle: Text(DateFormat.yMMMd().format(transaction.date)),
      ),
    );
  }
}
