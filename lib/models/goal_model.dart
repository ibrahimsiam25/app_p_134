class GoalModel {
  final String id;
  final double amount;
  final DateTime? deadline;
  final DateTime createdAt;
  final bool isCompleted;
  final bool hasShownSuccessDialog;
  final bool hasShownFailureDialog;

  GoalModel({
    required this.id,
    required this.amount,
    this.deadline,
    required this.createdAt,
    this.isCompleted = false,
    this.hasShownSuccessDialog = false,
    this.hasShownFailureDialog = false,
  });


  double calculateProgressPercentage(double currentAmount) {
    if (amount <= 0) return 0;
    double progress = (currentAmount / amount) * 100;
    return progress > 100 ? 100 : progress;
  }


  double calculateRemainingAmount(double currentAmount) {
    double remaining = amount - currentAmount;
    return remaining > 0 ? remaining : 0;
  }


  bool isAchievedWith(double currentAmount) {
    return currentAmount >= amount;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'deadline': deadline?.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'isCompleted': isCompleted,
      'hasShownSuccessDialog': hasShownSuccessDialog,
      'hasShownFailureDialog': hasShownFailureDialog,
    };
  }

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json['id'],
      amount: json['amount'].toDouble(),
      deadline: json['deadline'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['deadline'])
          : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      isCompleted: json['isCompleted'] ?? false,
      hasShownSuccessDialog: json['hasShownSuccessDialog'] ?? false,
      hasShownFailureDialog: json['hasShownFailureDialog'] ?? false,
    );
  }


  GoalModel copyWith({
    String? id,
    double? amount,
    DateTime? deadline,
    DateTime? createdAt,
    bool? isCompleted,
    bool? hasShownSuccessDialog,
    bool? hasShownFailureDialog,
  }) {
    return GoalModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      deadline: deadline ?? this.deadline,
      createdAt: createdAt ?? this.createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
      hasShownSuccessDialog: hasShownSuccessDialog ?? this.hasShownSuccessDialog,
      hasShownFailureDialog: hasShownFailureDialog ?? this.hasShownFailureDialog,
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
