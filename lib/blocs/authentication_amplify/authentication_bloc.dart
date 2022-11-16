import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:radency_internship_project_2/local_models/user.dart';
import 'package:radency_internship_project_2/providers/amplify_auth_service.dart';
import 'package:radency_internship_project_2/providers/firebase_auth_service.dart';

part 'authentication_event.dart';

part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AmplifyAuthenticationService authenticationService,
  })  : _authenticationService = authenticationService,
        super(const AuthenticationState.unknown()) {
    _userAuthStateSubscription = Amplify.Hub.listen([HubChannel.Auth], (hubEvent) {
      print("hubEvent.eventName = " + hubEvent.eventName);
      switch(hubEvent.eventName) {
        case 'SIGNED_IN':
          print('USER IS SIGNED IN');
          break;
        case 'SIGNED_OUT':
          print('USER IS SIGNED OUT');
          add(AuthenticationLogoutRequested());
          break;
        case 'SESSION_EXPIRED':
          print('SESSION HAS EXPIRED');
          add(AuthenticationLogoutRequested());
          break;
        case 'USER_DELETED':
          print('USER HAS BEEN DELETED');
          add(AuthenticationLogoutRequested());
          break;
      }
    });

    Amplify.Auth.fetchAuthSession().then((value) {
      bool isSignedIn = value.isSignedIn;
      if (!isSignedIn) {
        add(AuthenticationLogoutRequested());
      }
    });


    // _userAuthStateSubscription = _authenticationService.userFromAnyChanges.listen((userChanged) {
    //   /// Listens to changes of current firebase user (log in/log out/profile details modifying)
    //   /// Triggers change to auth state (means global navigation between homepage and sign in/sign up pages) ONLY if one of the following requirement is met:
    //   /// - user logged out;
    //   /// - user details were changed or it was manually reloaded via _firebase_auth.currentUser.reload() call
    //
    //   bool userLoggedOut = userChanged == UserEntity.empty;
    //   bool userWasNotAuthenticated = this.user == UserEntity.empty;
    //
    //   if (userLoggedOut || userWasNotAuthenticated) {
    //     add(AuthenticationUserChanged(userChanged));
    //   }
    //
    //   /// If user is logged in:
    //   /// 1) if email is not verified, after slight delay reloads firebase user; this action triggers new event in userFromAnyChanges stream;
    //   ///    so this reload will be repeatedly called until email will be verified;
    //   /// 2) if email was just verified, refreshes bloc state.
    //   ///
    //   /// This ("manual") constant reload is required because nor authStateChanges, nor userChanges are triggered when
    //   /// email is verified, so we must fetch verification status "automatically" (in some kind of loop), or
    //   /// maybe give user ability to do so (via "Check verification status" button?).
    //   if (userChanged != UserEntity.empty) {
    //     if (!userChanged.emailVerified) {
    //       _reloadUser();
    //     } else if (!this.user.emailVerified) {
    //       add(AuthenticationUserChanged(userChanged));
    //     }
    //   }
    // });
  }

  UserEntity user = UserEntity.empty;

  final AmplifyAuthenticationService _authenticationService;
  StreamSubscription<HubEvent>? _userAuthStateSubscription;

  @override
  Future<void> close() {
    _userAuthStateSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationUserChanged) {
      yield _mapAuthenticationUserChangedToState(event.user);
    } else if (event is AuthenticationLogoutRequested) {
      yield* _mapLogoutToState();
      // _authenticationService.logOut();
    } else if (event is AuthenticationEmailResendRequested) {
      yield* _mapAuthenticationEmailResendRequestedToState();
    }
  }

  AuthenticationState _mapAuthenticationUserChangedToState(
    UserEntity? userChanged,
  ) {
    if (userChanged == null || userChanged == UserEntity.empty) {
      user = UserEntity.empty;
      return const AuthenticationState.unauthenticated();
    } else {
      print("AuthenticationBloc._mapAuthenticationUserChangedToState: $userChanged");
      user = userChanged;
      return AuthenticationState.authenticated(user);
    }
  }

  Stream<AuthenticationState> _mapAuthenticationEmailResendRequestedToState() async* {
    // await _authenticationService.sendEmailVerification();
  }

  Stream<AuthenticationState> _mapLogoutToState() async* {
    await _authenticationService.logOut();
    yield AuthenticationState.unauthenticated();
  }

  // void _reloadUser() async {
  //   await Future.delayed(Duration(seconds: 10));
  //   await _authenticationService.reloadUser();
  // }
}
