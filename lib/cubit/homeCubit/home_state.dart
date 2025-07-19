
class HomeState {
  final double currentAmount;
  final bool isLoading;

  const HomeState({
    this.currentAmount = 0.0,
    this.isLoading = true,
  });

  HomeState copyWith({
    double? currentAmount,
    bool? isLoading,
  }) {
    return HomeState(
      currentAmount: currentAmount ?? this.currentAmount,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
