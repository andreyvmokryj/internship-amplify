part of 'sign_up_email_bloc.dart';

class SignUpEmailState extends Equatable {
  SignUpEmailState({
    this.areDetailsProcessing = false,
    this.errorMessage,
    this.biometricsAvailable = false,
    this.signUpFlowInitializationStatus = false,
  });

  final bool areDetailsProcessing;
  final String errorMessage;
  final bool biometricsAvailable;
  final bool signUpFlowInitializationStatus;

  @override
  List<Object> get props => [areDetailsProcessing, errorMessage, biometricsAvailable, signUpFlowInitializationStatus];

  SignUpEmailState setInitializationState({@required bool isInitialized, @required bool biometricAuthAvailable}) {
    return copyWith(signUpFlowInitializationStatus: isInitialized, biometricsAvailable: biometricAuthAvailable);
  }

  SignUpEmailState setDetailsProcessing() {
    return copyWith(areDetailsProcessing: true);
  }

  SignUpEmailState showError({@required String errorMessage}) {
    return copyWith(areDetailsProcessing: false, errorMessage: errorMessage);
  }

  SignUpEmailState copyWith({
    bool areDetailsProcessing,
    String errorMessage,
    bool signUpFlowInitializationStatus,
    bool biometricsAvailable,
  }) {
    return SignUpEmailState(
      signUpFlowInitializationStatus: signUpFlowInitializationStatus ?? this.signUpFlowInitializationStatus,
      biometricsAvailable: biometricsAvailable ?? this.biometricsAvailable,
      areDetailsProcessing: areDetailsProcessing ?? this.areDetailsProcessing,
      errorMessage: errorMessage ?? null,
    );
  }
}
