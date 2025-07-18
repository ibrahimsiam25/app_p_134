class IncomeModel {
  final String id;
  final String name;
  final double amount;
  final DateTime date;
  final bool isFromCurrentGoal;

  IncomeModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.date,
    this.isFromCurrentGoal = false,
  });

  // Convert IncomeModel to Map for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'date': date.millisecondsSinceEpoch,
      'isFromCurrentGoal': isFromCurrentGoal,
    };
  }

  // Create IncomeModel from Map
  factory IncomeModel.fromJson(Map<String, dynamic> json) {
    return IncomeModel(
      id: json['id'],
      name: json['name'],
      amount: json['amount'].toDouble(),
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
      isFromCurrentGoal: json['isFromCurrentGoal'] ?? false,
    );
  }

  // Create a copy of IncomeModel with updated fields
  IncomeModel copyWith({
    String? id,
    String? name,
    double? amount,
    DateTime? date,
    bool? isFromCurrentGoal,
  }) {
    return IncomeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      isFromCurrentGoal: isFromCurrentGoal ?? this.isFromCurrentGoal,
    );
  }

  @override
  String toString() {
    return 'IncomeModel(id: $id, name: $name, amount: $amount, date: $date, isFromCurrentGoal: $isFromCurrentGoal)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is IncomeModel && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}
