// ignore: file_names
// ignore_for_file: file_names
import 'dart:io';
import 'package:expense_planner/Widgets/adaptive_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function _addNewTransation;

  const NewTransaction(this._addNewTransation);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  void _submitData() {
    // if (_amountController.text.isEmpty) {
    //   return;
    // }
    final title = _titleController.text;
    final amount = double.parse(_amountController.text);

    if (title.isEmpty || amount <= 0 || _selectedDate == null) {
      return;
    }
    widget._addNewTransation(title, amount, _selectedDate);
    Navigator.of(context).pop();
  }

  void _presendDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      } else {
        setState(() {
          _selectedDate = pickedDate;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              right: 10,
              left: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            children: [
              TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Text'),
                  onSubmitted: (_) => _submitData()),
              TextField(
                decoration: const InputDecoration(labelText: 'Amount'),
                controller: _amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onSubmitted: (_) => _submitData(),
              ),
              SizedBox(
                height: 70,
                child: Row(
                  children: [
                    const SizedBox(height: 10),
                    Text(_selectedDate == null
                        ? "No Date Choosen"
                        : 'Picked Date : ${DateFormat.yMd().format(_selectedDate!)}'),
                    TextButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColor),
                        ),
                        onPressed: _presendDatePicker,
                        child: const Expanded(
                          child: Text(
                            'Choose Date',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ))
                  ],
                ),
              ),
              AdaptiveButton("Add Transacrtion", _submitData),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              )
            ],
          ),
        ),
      ),
    );
  }
}
