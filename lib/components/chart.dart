import 'package:expenses/components/char_bar.dart';
import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recenteTransactions;

  Chart(this.recenteTransactions);

  List<Map<String, Object>> get groupedTransactions {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );

      double totalSum = 0.0;

      for (var i = 0; i < recenteTransactions.length; i++) {
        bool sameDay = recenteTransactions[i].date.day == weekDay.day;
        bool sameMonth = recenteTransactions[i].date.month == weekDay.month;
        bool sameYear = recenteTransactions[i].date.year == weekDay.year;

        if (sameDay && sameMonth && sameYear) {
          totalSum = recenteTransactions[i].value;
        }
      }
      return {
        'day': DateFormat.E().format(weekDay)[0],
        'value': totalSum,
      };
    }).reversed.toList();
  }

  double get _weekTotalValue {
    return groupedTransactions.fold(0.0, (sum, tr) {
      return sum + double.parse(tr['value'].toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: groupedTransactions.map((tr) {
          return Flexible(
            fit: FlexFit.tight,
            child: ChartBar(
              label: tr['day'].toString(),
              value: double.parse(tr['value'].toString()),
              percentage:
                  _weekTotalValue == 0 ? 0 :double.parse(tr['value'].toString()) / _weekTotalValue,
            ),
          );
        }).toList(),
      ),
    );
  }
}
