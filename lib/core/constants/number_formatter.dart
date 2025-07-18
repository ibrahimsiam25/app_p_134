import 'package:app_p_134/models/transaction_model.dart';

String formatNumber(double value) {
  if (value % 1 == 0) {
    return value.toInt().toString();
  } else {
    return value.toStringAsFixed(1).replaceAll('.', ',');
  }
}

String formatPercent(double value) {
  final percent = value * 100;
  if (percent % 1 == 0) {
    return '${percent.toInt()}%';
  } else {
    return '${percent.toStringAsFixed(1).replaceAll('.', ',')}%';
  }
}
  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  String formatAmount(TransactionModel transaction) {
    final sign = transaction.isIncome ? '+' : '-';
    return '\$ $sign${transaction.amount.toStringAsFixed(0)}';
  }

  String formatCurrency(double amount) {
    return '\$ ${amount.toStringAsFixed(2)}';
  }