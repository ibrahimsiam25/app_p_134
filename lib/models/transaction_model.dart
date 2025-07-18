enum TransactionCategory { income, expense }

class TransactionModel {
  final String id;
  final String name;
  final double amount;
  final DateTime date;
  final TransactionCategory type;
  final bool isFromCurrentGoal;

  TransactionModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.date,
    required this.type,
    this.isFromCurrentGoal = false,
  });

  // Convert TransactionModel to Map for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'date': date.millisecondsSinceEpoch,
      'type': type.name, // Store as string
      'isFromCurrentGoal': isFromCurrentGoal,
    };
  }

  // Create TransactionModel from Map
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      name: json['name'],
      amount: json['amount'].toDouble(),
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
      type: TransactionCategory.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => TransactionCategory.income,
      ),
      isFromCurrentGoal: json['isFromCurrentGoal'] ?? false,
    );
  }

  // Create a copy of TransactionModel with updated fields
  TransactionModel copyWith({
    String? id,
    String? name,
    double? amount,
    DateTime? date,
    TransactionCategory? type,
    bool? isFromCurrentGoal,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      type: type ?? this.type,
      isFromCurrentGoal: isFromCurrentGoal ?? this.isFromCurrentGoal,
    );
  }

  // Convenience methods to check transaction type
  bool get isIncome => type == TransactionCategory.income;
  bool get isExpense => type == TransactionCategory.expense;

  // Factory methods for creating specific types
  factory TransactionModel.income({
    required String id,
    required String name,
    required double amount,
    required DateTime date,
    bool isFromCurrentGoal = false,
  }) {
    return TransactionModel(
      id: id,
      name: name,
      amount: amount,
      date: date,
      type: TransactionCategory.income,
      isFromCurrentGoal: isFromCurrentGoal,
    );
  }

  factory TransactionModel.expense({
    required String id,
    required String name,
    required double amount,
    required DateTime date,
    bool isFromCurrentGoal = false,
  }) {
    return TransactionModel(
      id: id,
      name: name,
      amount: amount,
      date: date,
      type: TransactionCategory.expense,
      isFromCurrentGoal: isFromCurrentGoal,
    );
  }

  // Factory methods for legacy data migration
  factory TransactionModel.fromIncome(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      name: json['name'],
      amount: json['amount'].toDouble(),
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
      type: TransactionCategory.income,
      isFromCurrentGoal: json['isFromCurrentGoal'] ?? false,
    );
  }

  factory TransactionModel.fromExpense(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      name: json['name'],
      amount: json['amount'].toDouble(),
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
      type: TransactionCategory.expense,
      isFromCurrentGoal: json['isFromCurrentGoal'] ?? false,
    );
  }

  @override
  String toString() {
    return 'TransactionModel(id: $id, name: $name, amount: $amount, date: $date, type: $type, isFromCurrentGoal: $isFromCurrentGoal)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TransactionModel && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}
