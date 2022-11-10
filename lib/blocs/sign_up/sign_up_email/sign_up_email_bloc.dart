import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:radency_internship_project_2/generated/l10n.dart';
import 'package:radency_internship_project_2/providers/biometric_credentials_service.dart';
import 'package:radency_internship_project_2/providers/firebase_auth_service.dart';

part 'sign_up_email_event.dart';

part 'sign_up_email_state.dart';

class SignUpEmailBloc extends Bloc<SignUpEmailEvent, SignUpEmailState> {
  SignUpEmailBloc(this._authenticationService, this._biometricCredentialsService)
      : assert(_authenticationService != null),
        super(SignUpEmailState());

  final FirebaseAuthenticationService _authenticationService;
  final BiometricCredentialsService _biometricCredentialsService;

  bool areBiometricsEnrolled = false;

  @override
  Stream<SignUpEmailState> mapEventToState(SignUpEmailEvent event) async* {
    if (event is SignUpEmailSubmitted) {
      yield* _mapSignUpEmailSubmittedToState(
        email: event.email,
        password: event.password,
        username: event.username,
        biometricsPairingStatus: event.biometricsPairingStatus,
      );
    } else if (event is SignUpEmailInitialize) {
      yield* _mapSignUpEmailInitializeToState();
    }
  }

  Stream<SignUpEmailState> _mapSignUpEmailInitializeToState() async* {
    areBiometricsEnrolled = await _biometricCredentialsService.checkIfAnyBiometricsEnrolled();

    yield state.setInitializationState(isInitialized: true, biometricAuthAvailable: areBiometricsEnrolled);
  }

  Stream<SignUpEmailState> _mapSignUpEmailSubmittedToState({
    @required String email,
    @required String password,
    @required String username,
    @required bool biometricsPairingStatus,
  }) async* {
    yield state.setDetailsProcessing();

    bool didAuthenticateWithBiometrics = false;

    if (biometricsPairingStatus) {
      didAuthenticateWithBiometrics = await _biometricCredentialsService.authenticate(reason: S.current.authenticationBiometricsReasonSave);
      if (!didAuthenticateWithBiometrics) {
        yield state.showError(errorMessage: S.current.authenticationBiometricsFailure);
      }
    }

    if (didAuthenticateWithBiometrics || !biometricsPairingStatus) {
      try {
        await _authenticationService.signUpWithEmailAndPassword(email: email, password: password, username: username);
        if (biometricsPairingStatus) {
          await _biometricCredentialsService.saveBiometricCredentials(email: email, password: password);
        }
      } on FirebaseAuthException catch (exception) {
        // TODO: localize FB-related errors
        yield state.showError(errorMessage: exception.message);
      } catch (e) {
        yield state.showError(errorMessage: e.toString());
      }
    }
  }
}
