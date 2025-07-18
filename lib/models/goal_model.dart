class GoalModel {
  final String id;
  final double amount;
  final DateTime? deadline;
  final DateTime createdAt;
  final bool isCompleted;

  GoalModel({
    required this.id,
    required this.amount,
    this.deadline,
    required this.createdAt,
    this.isCompleted = false,
  });

  // Convert GoalModel to Map for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'deadline': deadline?.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'isCompleted': isCompleted,
    };
  }

  // Create GoalModel from Map
  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json['id'],
      amount: json['amount'].toDouble(),
      deadline: json['deadline'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['deadline'])
          : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  // Create a copy of GoalModel with updated fields
  GoalModel copyWith({
    String? id,
    double? amount,
    DateTime? deadline,
    DateTime? createdAt,
    bool? isCompleted,
  }) {
    return GoalModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      deadline: deadline ?? this.deadline,
      createdAt: createdAt ?? this.createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  String toString() {
    return 'GoalModel(id: $id, amount: $amount, deadline: $deadline, createdAt: $createdAt, isCompleted: $isCompleted)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GoalModel && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}
