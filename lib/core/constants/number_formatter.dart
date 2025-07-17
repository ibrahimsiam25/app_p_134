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
