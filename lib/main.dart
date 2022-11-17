import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:radency_internship_project_2/amplifyconfiguration.dart';
import 'package:radency_internship_project_2/models/ModelProvider.dart';
import 'package:radency_internship_project_2/providers/amplify_auth_service.dart';
import 'package:radency_internship_project_2/providers/biometric_credentials_service.dart';
import 'package:radency_internship_project_2/providers/firebase_functions_provider.dart';
import 'package:radency_internship_project_2/providers/firebase_realtime_database_provider.dart';
import 'package:radency_internship_project_2/providers/hive/hive_provider.dart';
import 'package:radency_internship_project_2/repositories/budgets_repository.dart';
import 'package:radency_internship_project_2/repositories/transactions_repository.dart';

import 'app.dart';
import 'providers/firebase_auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _configureAmplify();
  final FirebaseApp app = await Firebase.initializeApp();

  var directory = await path_provider.getApplicationDocumentsDirectory();
  await HiveProvider().initializeHive(directory.path);

  // final FirebaseDatabase database = FirebaseDatabase(
  //     databaseURL: 'https://radency-internship-2-yokoy-default-rtdb.europe-west1.firebasedatabase.app');
  // database.setPersistenceEnabled(true);
  // database.setPersistenceCacheSizeBytes(10000000);
  //
  // FirebaseAuthenticationService firebaseAuthenticationService = FirebaseAuthenticationService();
  AmplifyAuthenticationService amplifyAuthenticationService = AmplifyAuthenticationService();
  // FirebaseRealtimeDatabaseProvider firebaseRealtimeDatabaseProvider =
  //     FirebaseRealtimeDatabaseProvider(database: database);
  TransactionsRepository transactionsRepository = TransactionsRepository(
      // firebaseRealtimeDatabaseProvider: firebaseRealtimeDatabaseProvider,
      amplifyAuthenticationService: amplifyAuthenticationService);
  FirebaseFunctionsProvider firebaseFunctionsProvider = FirebaseFunctionsProvider();

  runApp(Authenticator(
    child: App(
      // authenticationService: firebaseAuthenticationService,
      amplifyAuthenticationService: amplifyAuthenticationService,
      biometricCredentialsService: BiometricCredentialsService(),
      budgetsRepository: BudgetsRepository(),
      // firebaseRealtimeDatabaseProvider: firebaseRealtimeDatabaseProvider,
      transactionsRepository: transactionsRepository,
      firebaseFunctionsProvider: firebaseFunctionsProvider,
    ),
  ));
}

Future<void> _configureAmplify() async {

  await Amplify.addPlugin(AmplifyAPI()); // UNCOMMENT this line after backend is deployed
  await Amplify.addPlugin(AmplifyDataStore(modelProvider: ModelProvider.instance));
  final auth = AmplifyAuthCognito();
  await Amplify.addPlugin(auth);

  // Once Plugins are added, configure Amplify
  await Amplify.configure(amplifyconfig);
}
