enum AppStartupStatus { idle, loading, ready, error }

class AppStartupState {
  const AppStartupState({required this.status, this.errorMessage});

  final AppStartupStatus status;
  final String? errorMessage;

  const AppStartupState.idle()
    : status = AppStartupStatus.idle,
      errorMessage = null;

  const AppStartupState.loading()
    : status = AppStartupStatus.loading,
      errorMessage = null;

  const AppStartupState.ready()
    : status = AppStartupStatus.ready,
      errorMessage = null;

  const AppStartupState.error(this.errorMessage)
    : status = AppStartupStatus.error;

  AppStartupState copyWith({AppStartupStatus? status, String? errorMessage}) {
    return AppStartupState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
