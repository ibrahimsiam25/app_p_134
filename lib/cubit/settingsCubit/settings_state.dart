enum SettingsStatus {
  initial,
  permissionGranted,
  privacyPolicyOpened,
  appShared,
  error,
}

class SettingsState {
  final SettingsStatus status;
  final String? message;

  const SettingsState({
    this.status = SettingsStatus.initial,
    this.message,
  });

  SettingsState copyWith({
    SettingsStatus? status,
    String? message,
  }) {
    return SettingsState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}
