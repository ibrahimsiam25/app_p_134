class ExpenseModel {
  final String id;
  final String name;
  final double amount;
  final DateTime date;
  final bool isFromCurrentGoal;

  ExpenseModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.date,
    this.isFromCurrentGoal = false,
  });

  // Convert ExpenseModel to Map for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'date': date.millisecondsSinceEpoch,
      'isFromCurrentGoal': isFromCurrentGoal,
    };
  }

  // Create ExpenseModel from Map
  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'],
      name: json['name'],
      amount: json['amount'].toDouble(),
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
      isFromCurrentGoal: json['isFromCurrentGoal'] ?? false,
    );
  }

  // Create a copy of ExpenseModel with updated fields
  ExpenseModel copyWith({
    String? id,
    String? name,
    double? amount,
    DateTime? date,
    bool? isFromCurrentGoal,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      isFromCurrentGoal: isFromCurrentGoal ?? this.isFromCurrentGoal,
    );
  }

  @override
  String toString() {
    return 'ExpenseModel(id: $id, name: $name, amount: $amount, date: $date, isFromCurrentGoal: $isFromCurrentGoal)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExpenseModel && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}
