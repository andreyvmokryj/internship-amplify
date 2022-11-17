// import 'dart:async';
//
// import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:radency_internship_project_2/local_models/user.dart';
//
// class SignUpFailure implements Exception {}
//
// class LogInWithPhoneNumberFailure implements Exception {}
//
// class SignUpWithPhoneNumberFailure implements Exception {
//   final String message;
//
//   SignUpWithPhoneNumberFailure({required this.message});
// }
//
// class LogOutFailure implements Exception {}
//
// class FirebaseAuthenticationService {
//   FirebaseAuthenticationService({
//     firebase_auth.FirebaseAuth? firebaseAuth,
//   }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;
//
//   final firebase_auth.FirebaseAuth _firebaseAuth;
//
//   Stream<UserEntity> get userFromAuthState {
//     return _firebaseAuth.authStateChanges().map((firebaseUser) {
//       print("authenticationService.user: user changed ${firebaseUser?.uid ?? null}");
//       return firebaseUser == null ? UserEntity.empty : firebaseUser.toUserEntity;
//     });
//   }
//
//   Stream<UserEntity> get userFromAnyChanges {
//     return _firebaseAuth.userChanges().map((firebaseUser) {
//       print("authenticationService.user: user changed ${firebaseUser?.uid ?? null}");
//       return firebaseUser == null ? UserEntity.empty : firebaseUser.toUserEntity;
//     });
//   }
//
//   Future<void> signInWithPhoneCredential(
//       {required AuthCredential authCredential, String? email, String? username}) async {
//     User? firebaseUser;
//     await _firebaseAuth.signInWithCredential(authCredential).then((value) async {
//       firebaseUser = value.user;
//       if (firebaseUser?.email == null || firebaseUser?.displayName == null) {
//         // Logging out if user haven't completed registration flow
//         await logOut();
//         throw SignUpWithPhoneNumberFailure(message: 'This account is not yet registered!');
//       }
//     });
//
//     await _firebaseAuth.currentUser?.reload();
//   }
//
//   Future<void> signInWithPhoneCredentialAndUpdateProfile(
//       {required AuthCredential authCredential, String? email, String? username}) async {
//     User? firebaseUser;
//     await _firebaseAuth.signInWithCredential(authCredential).then((value) {
//       firebaseUser = value.user;
//     });
//
//     if (firebaseUser?.email != null || firebaseUser?.displayName != null) {
//       throw SignUpWithPhoneNumberFailure(message: 'This account is already registered!');
//     }
//
//     if (email != null) {
//       await firebaseUser?.updateEmail(email);
//     }
//     await firebaseUser?.updateDisplayName(username);
//     await _firebaseAuth.currentUser?.reload();
//   }
//
//   Future<void> startPhoneNumberAuthentication({
//     required
//         String phoneNumber,
//     required
//         codeAutoRetrievalTimeout(String verificationId),
//     required
//         verificationFailed(FirebaseAuthException error),
//     required
//         codeSent(String verificationId, int? forceResendingToken),
//     required
//         verificationCompleted(
//       PhoneAuthCredential phoneAuthCredential,
//     ),
//     int? forceResendingToken ,
//   }) async {
//     try {
//       await _firebaseAuth.verifyPhoneNumber(
//           codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
//           verificationFailed: verificationFailed,
//           phoneNumber: phoneNumber,
//           codeSent: codeSent,
//           forceResendingToken: forceResendingToken,
//           verificationCompleted: verificationCompleted);
//     } on Exception {
//       throw LogInWithPhoneNumberFailure();
//     }
//   }
//
//   Future<void> signInWithEmailAndPassword({required String email, required String password}) async {
//     await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
//   }
//
//   Future<void> signUpWithEmailAndPassword(
//       {required String email, required String password, required String username}) async {
//     await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
//
//     User? firebaseUser;
//     await _firebaseAuth
//         .signInWithEmailAndPassword(email: email, password: password)
//         .then((value) => firebaseUser = value.user);
//
//     await firebaseUser?.updateDisplayName(username);
//     await _firebaseAuth.currentUser?.reload();
//
//     await sendEmailVerification();
//   }
//
//   Future<void> sendEmailVerification() async {
//     await _firebaseAuth.currentUser?.sendEmailVerification();
//   }
//
//   Future<void> reloadUser() async {
//     await _firebaseAuth.currentUser?.reload();
//   }
//
//   Future<String> getUserID() async {
//     firebase_auth.User? user = _firebaseAuth.currentUser;
//     return user?.uid ?? "";
//   }
//
//   Future<void> logOut() async {
//     try {
//       await Future.wait([
//         _firebaseAuth.signOut(),
//       ]);
//     } on Exception {
//       throw LogOutFailure();
//     }
//   }
// }
//
// extension on firebase_auth.User {
//   UserEntity get toUserEntity {
//     return UserEntity(id: uid, email: email, name: displayName, photo: photoURL, emailVerified: emailVerified);
//   }
// }
