import 'dart:io';
import 'package:expense_planner/Widgets/transaction_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'Widgets/new_transaction.dart';

import 'package:flutter/material.dart';

import 'Models/Transaction.dart';
import 'Widgets/chart.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Expenses",
      theme: ThemeData(
          primarySwatch: Colors.purple,
          // ignore: deprecated_member_use
          accentColor: Colors.orange,
          errorColor: Colors.red,
          textTheme: ThemeData.light().textTheme.copyWith(
              subtitle1: const TextStyle(
                  fontFamily: 'OpenSans', fontWeight: FontWeight.bold),
              button: TextStyle(color: Colors.red)),
          appBarTheme: AppBarTheme(
              // ignore: deprecated_member_use
              textTheme: ThemeData.light().textTheme.copyWith(
                  subtitle1: const TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 10,
                      fontWeight: FontWeight.bold))),
          fontFamily: 'Quicksand'),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }

  final List<Transaction> _userTransactions = [];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime date) {
    final tx = Transaction(
        id: DateTime.now().toString(),
        title: title,
        amount: amount,
        date: date);

    setState(() {
      _userTransactions.add(tx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  void _startAddNewtransaction(BuildContext ctx) {
    // builder contrains the widgets that should be inside the sheet.
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
              onTap: () {},
              child: NewTransaction(_addNewTransaction),
              behavior: HitTestBehavior.deferToChild);
        });
  }

  List<Widget> _buildLandscapContent(MediaQueryData mediaQuery,
      ObstructingPreferredSizeWidget appBar, Widget txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Show Chart",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Switch.adaptive(
            activeColor: Theme.of(context).accentColor,
            value: _showChart,
            onChanged: (value) {
              setState(() {
                _showChart = !_showChart;
              });
            },
          ),
        ],
      ),
      _showChart
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              child: Chart(_recentTransactions),
            )
          : txListWidget
    ];
  }

  List<Widget> _buildPortraitContent(MediaQueryData mediaQuery,
      ObstructingPreferredSizeWidget appBar, Widget txListWidget) {
    return [
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(_recentTransactions),
      ),
      txListWidget
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandScape = mediaQuery.orientation == Orientation.landscape;
    final ObstructingPreferredSizeWidget appBar = (Platform.isIOS
        ? CupertinoNavigationBar(
            middle: const Text("Expenses"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: const Icon(CupertinoIcons.add),
                  onTap: () => _startAddNewtransaction(context),
                )
              ],
            ),
          )
        : AppBar(
            title: const Text("Expenses"),
            actions: [
              IconButton(
                  onPressed: () => _startAddNewtransaction(context),
                  icon: const Icon(Icons.add))
            ],
          )) as ObstructingPreferredSizeWidget;

    final txListWidget = Container(
      height: (mediaQuery.size.height - appBar.preferredSize.height) * 0.7,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );
    final bodyWidget = SafeArea(
      child: SingleChildScrollView(
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          if (!isLandScape)
            ..._buildPortraitContent(
              mediaQuery,
              appBar,
              txListWidget,
            ),
          // landscape ...
          if (isLandScape)
            ..._buildLandscapContent(
              mediaQuery,
              appBar,
              txListWidget,
            ),
        ]),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: bodyWidget,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: bodyWidget,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () => _startAddNewtransaction(context)),
          );
  }
}

/**
 * Notes:
 * 1 - late to field means that the field will be initialized when you use it for the first time.
 * enforce this variable’s constraints at runtime instead of at compile time
 * 
 * 2 - BuildContext : Things allows my Widget to figure out where my widget is.
 *  it give your widget build method the context it needs.
 * 
 * 3. widget object :  I can access this function now even though i am in a different class.
 * it only available in state classes. such as  [
 *        Transaction Class - available in -> TransactionState Class
 *  ]
 * 
 * 4. Context : is a special property which is available in 
 * your state class .The location in the tree where this widget builds.
 * it is available because we extends State<MyHomePage>.
  
 */
