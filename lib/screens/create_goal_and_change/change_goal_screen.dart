import 'package:app_p_134/widgets/price_amount_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../cubit/goalFormCubit/goal_form_cubit.dart';
import '../../cubit/goalFormCubit/goal_form_state.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_back_app_bar.dart';
import '../../widgets/custom_snack_bar.dart';
import '../../widgets/coustom_dialog.dart';
import 'widgets/deadline_section.dart';
import 'widgets/create_goal_functions.dart';


class ChangeGoalScreen extends StatefulWidget {
  const ChangeGoalScreen({super.key, required this.initialGoalAmount, this.initialDeadline});
  final double initialGoalAmount;
  final DateTime? initialDeadline;
  @override
  State<ChangeGoalScreen> createState() => _ChangeGoalScreenState();
}

class _ChangeGoalScreenState extends State<ChangeGoalScreen> {
  late final TextEditingController _goalAmountController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _goalAmountController = TextEditingController(text: widget.initialGoalAmount.toStringAsFixed(2));
  }

  @override
  void dispose() {
    _goalAmountController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _showDatePicker(BuildContext validContext,GoalFormState state) {
    CreateGoalFunctions.showDatePicker(
  context: validContext,
      selectedDate: state.selectedDate,
      onDateSelected: (DateTime? newDate) {
        if (newDate != null) {
         validContext.read<GoalFormCubit>().updateSelectedDate(newDate);
        }
      },
    );
  }

  void _showTimePicker(BuildContext validContext,) {
    CreateGoalFunctions.showTimePicker(
      context: validContext,
      selectedTime: validContext.read<GoalFormCubit>().state.selectedTime,
      onTimeSelected: (TimeOfDay newTime) {
         validContext.read<GoalFormCubit>().updateSelectedTime(newTime);
      },
    );
  }

  void _onBackPressed(GoalFormState state) {
    if (state.hasUnsavedData) {
      showDialog(
        context: context,
        builder: (context) => CoustomDialog(
          title: 'Heads up!',
          message: 'If you exit, you\'ll lose any unsaved work.',
          primaryLabel: "Exit",
          secondaryLabel: "Cancel",
          onSecondary: () => Navigator.of(context).pop(),
          onPrimary: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        ),
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<void> _updateGoal() async {
    await context.read<GoalFormCubit>().saveGoal(
      context,
      onSuccess: () {
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GoalFormCubit()..initializeWithExistingGoal(
        initialGoalAmount: widget.initialGoalAmount,
        initialDeadline: widget.initialDeadline,
      ),
      child: BlocConsumer<GoalFormCubit, GoalFormState>(
        listener: (context, state) {
          if (state is GoalFormSuccessState) {
            CustomSnackBar.show(
              context,
              message: state.successMessage,
              isSuccess: true,
            );
          } else if (state is GoalFormErrorState) {
            CustomSnackBar.show(
              context,
              message: state.errorMessage,
              isError: true,
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: AppColors.white,
            appBar: CustomBackAppBar(
              title: 'Change a goal',
              onBackPressed: () => _onBackPressed(state),
            ),
            body: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PriceAmountInput(
                          title: 'Goal amount',
                          controller: _goalAmountController,
                          focusNode: _focusNode,
                          onChanged: () {
                            context.read<GoalFormCubit>().updateGoalAmount(_goalAmountController.text);
                          },
                        ),

                        SizedBox(height: 32.h),

                        DeadlineSection(
                          isDeadlineSet: state.isDeadlineSet,
                          selectedDate: state.selectedDate,
                          selectedTime: state.selectedTime,
                          onDeadlineChanged: (bool? value) {
                            context.read<GoalFormCubit>().updateDeadlineSet(value ?? false);
                          },
                          onDateTap: () => _showDatePicker(context,state),
                          onTimeTap: () => _showTimePicker(context),
                        ),

                        const Spacer(),

                        AppButton(
                          text: 'Save',
                          onTap: state.isFormValid ? _updateGoal : null,
                          containerColor: state.isFormValid ? AppColors.green : AppColors.white,
                          fontColor: state.isFormValid ? AppColors.blackLight : AppColors.gray,
                          borderColor: state.isFormValid ? null : AppColors.gray,
                          width: double.infinity,
                          height: 60.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
