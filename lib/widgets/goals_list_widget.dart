import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/database/local_date.dart';
import '../../models/goal_model.dart';
import 'custom_snack_bar.dart';

class GoalsListWidget extends StatefulWidget {
  const GoalsListWidget({super.key});

  @override
  State<GoalsListWidget> createState() => _GoalsListWidgetState();
}

class _GoalsListWidgetState extends State<GoalsListWidget> {
  GoalModel? currentGoal;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGoal();
  }

  Future<void> _loadGoal() async {
    try {
      GoalModel? loadedGoal = await LocalData.getCurrentGoal();
      setState(() {
        currentGoal = loadedGoal;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading goal: $e');
    }
  }

  Future<void> _updateGoalCompletion(bool isCompleted) async {
    bool success = await LocalData.updateGoalCompletion(isCompleted);
    if (success) {
      _loadGoal(); // Reload goal to reflect changes
      CustomSnackBar.show(
        context,
        message: isCompleted ? 'Goal marked as completed!' : 'Goal marked as incomplete',
        isSuccess: isCompleted,
      );
    }
  }

  String _formatDeadline(DateTime? deadline) {
    if (deadline == null) return 'No deadline';
    
    final now = DateTime.now();
    final difference = deadline.difference(now).inDays;
    
    if (difference < 0) {
      return 'Overdue by ${-difference} days';
    } else if (difference == 0) {
      return 'Due today';
    } else {
      return 'Due in $difference days';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (currentGoal == null) {
      return Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.track_changes,
              size: 48.w,
              color: AppColors.gray,
            ),
            SizedBox(height: 16.h),
            Text(
              'No goal yet',
              style: AppTextStyles.header18.copyWith(
                color: AppColors.gray,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Create your first goal to get started!',
              style: AppTextStyles.header14.copyWith(
                color: AppColors.gray,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadGoal,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: _buildGoalCard(currentGoal!),
      ),
    );
  }

  Widget _buildGoalCard(GoalModel goal) {
    final isOverdue = goal.deadline != null && 
                    goal.deadline!.isBefore(DateTime.now()) && 
                    !goal.isCompleted;
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: goal.isCompleted 
              ? AppColors.gren 
              : isOverdue 
                  ? Colors.red.shade300
                  : AppColors.gray.withOpacity(0.3),
          width: goal.isCompleted ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.gray.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$${goal.amount.toStringAsFixed(0)}',
                      style: AppTextStyles.header18.copyWith(
                        color: goal.isCompleted ? AppColors.gren : AppColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      _formatDeadline(goal.deadline),
                      style: AppTextStyles.header12.copyWith(
                        color: isOverdue && !goal.isCompleted 
                            ? Colors.red 
                            : AppColors.gray,
                      ),
                    ),
                  ],
                ),
              ),
              Checkbox(
                value: goal.isCompleted,
                onChanged: (value) {
                  _updateGoalCompletion(value ?? false);
                },
                activeColor: AppColors.gren,
              ),
            ],
          ),
          if (goal.deadline != null) ...[
            SizedBox(height: 8.h),
            Text(
              'Deadline: ${goal.deadline!.day}/${goal.deadline!.month}/${goal.deadline!.year} at ${goal.deadline!.hour.toString().padLeft(2, '0')}:${goal.deadline!.minute.toString().padLeft(2, '0')}',
              style: AppTextStyles.header12.copyWith(
                color: AppColors.gray,
              ),
            ),
          ],
          SizedBox(height: 8.h),
          Text(
            'Created: ${goal.createdAt.day}/${goal.createdAt.month}/${goal.createdAt.year}',
            style: AppTextStyles.header12.copyWith(
              color: AppColors.gray,
            ),
          ),
        ],
      ),
    );
  }
}
