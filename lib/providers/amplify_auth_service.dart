import 'dart:async';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:radency_internship_project_2/local_models/user.dart';

class SignUpFailure implements Exception {}

class LogInWithPhoneNumberFailure implements Exception {}

class SignUpWithPhoneNumberFailure implements Exception {
  final String message;

  SignUpWithPhoneNumberFailure({required this.message});
}

class LogOutFailure implements Exception {}

class AmplifyAuthenticationService {
  StreamSubscription<HubEvent> hubSubscription = Amplify.Hub.listen([HubChannel.Auth], (hubEvent) {
    switch(hubEvent.eventName) {
      case 'SIGNED_IN':
        print('USER IS SIGNED IN');
        break;
      case 'SIGNED_OUT':
        print('USER IS SIGNED OUT');
        break;
      case 'SESSION_EXPIRED':
        print('SESSION HAS EXPIRED');
        break;
      case 'USER_DELETED':
        print('USER HAS BEEN DELETED');
        break;
    }
  });



  // Stream<UserEntity> get userFromAuthState {
  //   return FirebaseAuth.instance.authStateChanges().map((firebaseUser) {
  //     print("authenticationService.user: user changed ${firebaseUser?.uid ?? null}");
  //     return firebaseUser == null ? UserEntity.empty : firebaseUser.toUserEntity;
  //   });
  // }
  //
  // Stream<UserEntity> get userFromAnyChanges {
  //   return _amplifyAuth.userChanges().map((firebaseUser) {
  //     print("authenticationService.user: user changed ${firebaseUser?.uid ?? null}");
  //     return firebaseUser == null ? UserEntity.empty : firebaseUser.toUserEntity;
  //   });
  // }

  // Future<void> signInWithPhoneCredential(
  //     {required AuthCredential authCredential, String? email, String? username}) async {
  //   User? firebaseUser;
  //   await _amplifyAuth.signInWithCredential(authCredential).then((value) async {
  //     firebaseUser = value.user;
  //     if (firebaseUser?.email == null || firebaseUser?.displayName == null) {
  //       // Logging out if user haven't completed registration flow
  //       await logOut();
  //       throw SignUpWithPhoneNumberFailure(message: 'This account is not yet registered!');
  //     }
  //   });
  //
  //   await _amplifyAuth.currentUser?.reload();
  // }

  // Future<void> signInWithPhoneCredentialAndUpdateProfile(
  //     {required AuthCredential authCredential, String? email, String? username}) async {
  //   User? firebaseUser;
  //   await _amplifyAuth.signInWithCredential(authCredential).then((value) {
  //     firebaseUser = value.user;
  //   });
  //
  //   if (firebaseUser?.email != null || firebaseUser?.displayName != null) {
  //     throw SignUpWithPhoneNumberFailure(message: 'This account is already registered!');
  //   }
  //
  //   if (email != null) {
  //     await firebaseUser?.updateEmail(email);
  //   }
  //   await firebaseUser?.updateDisplayName(username);
  //   await _amplifyAuth.currentUser?.reload();
  // }

  // Future<void> startPhoneNumberAuthentication({
  //   required
  //       String phoneNumber,
  //   required
  //       codeAutoRetrievalTimeout(String verificationId),
  //   required
  //       verificationFailed(FirebaseAuthException error),
  //   required
  //       codeSent(String verificationId, int? forceResendingToken),
  //   required
  //       verificationCompleted(
  //     PhoneAuthCredential phoneAuthCredential,
  //   ),
  //   int? forceResendingToken ,
  // }) async {
  //   try {
  //     await _amplifyAuth.verifyPhoneNumber(
  //         codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
  //         verificationFailed: verificationFailed,
  //         phoneNumber: phoneNumber,
  //         codeSent: codeSent,
  //         forceResendingToken: forceResendingToken,
  //         verificationCompleted: verificationCompleted);
  //   } on Exception {
  //     throw LogInWithPhoneNumberFailure();
  //   }
  // }

  Future<void> signInWithEmailAndPassword({required String email, required String password}) async {
    await Amplify.Auth.signIn(
      username: email,
      password: password,
    );
  }

  Future<void> signUpWithEmailAndPassword(
      {required String email, required String password, required String username}) async {
    final userAttributes = <CognitoUserAttributeKey, String>{
      CognitoUserAttributeKey.nickname: username,
      // CognitoUserAttributeKey.phoneNumber: '+15559101234',
      // additional attributes as needed
    };

    // await _amplifyAuth.createUserWithEmailAndPassword(email: email, password: password);
    await Amplify.Auth.signUp(
      username: email,
      password: password,
      options: CognitoSignUpOptions(userAttributes: userAttributes),
    );

    // User? firebaseUser;
    await Amplify.Auth.signIn(username: email, password: password);
        // .then((value) => firebaseUser = value);

    // await firebaseUser?.updateDisplayName(username);
    // await _amplifyAuth.currentUser?.reload();
    //
    // await sendEmailVerification();
  }

  Future<void> confirmSignUp({required String email, required String code}) async {
    await Amplify.Auth.confirmSignUp(
      username: email,
      confirmationCode: code,
    );

  }

  // Future<void> sendEmailVerification() async {
  //
  //   (await _amplifyAuth.getCurrentUser())?.sendEmailVerification();
  // }

  // Future<void> reloadUser() async {
  //   await _amplifyAuth.currentUser?.reload();
  // }

  Future<String> getUserID() async {
    AuthUser? user = await Amplify.Auth.getCurrentUser();
    return user.userId ?? "";
  }

  Future<void> logOut() async {
    try {
      await Future.wait([
        Amplify.Auth.signOut(),
      ]);
    } on Exception {
      throw LogOutFailure();
    }
  }
}

// extension on AuthUser {
//   UserEntity get toUserEntity {
//     return UserEntity(id: uid, email: email, name: displayName, photo: photoURL, emailVerified: emailVerified);
//   }
// }
