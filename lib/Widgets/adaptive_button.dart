// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class AdaptiveButton extends StatelessWidget {
  final VoidCallback _handler;
  final String _text;
  const AdaptiveButton(this._text, this._handler);
  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            color: Theme.of(context).primaryColor,
            child: Text(_text),
            onPressed: _handler)
        : ElevatedButton(
            child: Text(_text),
            //  i have an argument but i did not care about it.
            onPressed: _handler,
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(
                Theme.of(context).accentColor,
              ),
              backgroundColor:
                  MaterialStateProperty.all(Theme.of(context).primaryColor),
            ),
          );
  }
}
