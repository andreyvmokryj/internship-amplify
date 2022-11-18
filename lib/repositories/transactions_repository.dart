import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:collection/collection.dart';
// import 'package:radency_internship_project_2/local_models/transactions/transaction.dart';
import 'package:radency_internship_project_2/local_models/transactions/transactions_helper.dart';
import 'package:radency_internship_project_2/models/AppTransaction.dart';
import 'package:radency_internship_project_2/providers/amplify_auth_service.dart';
import 'package:radency_internship_project_2/providers/firebase_auth_service.dart';
import 'package:radency_internship_project_2/providers/firebase_realtime_database_provider.dart';
import 'package:radency_internship_project_2/repositories/repository.dart';

class TransactionsRepository extends IRepository<AppTransaction> {
  TransactionsRepository({
    // required this.firebaseRealtimeDatabaseProvider,
    required this.amplifyAuthenticationService
  });

  // final FirebaseRealtimeDatabaseProvider firebaseRealtimeDatabaseProvider;
  final AmplifyAuthenticationService amplifyAuthenticationService;

  @override
  Future<void> add(AppTransaction transaction) async {
    String uid = await amplifyAuthenticationService.getUserID();
    // await firebaseRealtimeDatabaseProvider.transactionsReference(uid).then((reference) async {
    //   Map<String, dynamic> transactionMap = TransactionsHelper().convertTransactionToJson(transaction: transaction);
    //   await reference.push().set(transactionMap);
    // });
    await Amplify.DataStore.save(transaction.copyWith(userID: uid));
  }

  @override
  Future<void> delete({String? transactionID}) async {
    String uid = await amplifyAuthenticationService.getUserID();
    // await firebaseRealtimeDatabaseProvider.transactionsReference(uid).then((reference) async {
    //   await reference.child(transactionID!).remove();
    // });

    final snapshot = await find(transactionID: transactionID);
    if (snapshot != null) {
      await Amplify.DataStore.delete(snapshot);
    }
  }

  @override
  Future<AppTransaction?> find({String? transactionID}) async {
    AppTransaction? transaction;

    String uid = await amplifyAuthenticationService.getUserID();
    // await firebaseRealtimeDatabaseProvider.transactionsReference(uid).then((reference) async {
    //   await reference.child(transactionID!).once().then((event) async {
    //     if (event.snapshot.value != null) {
    //       transaction = TransactionsHelper()
    //           .convertJsonToTransaction(json: Map<String, dynamic>.from(event.snapshot.value as Map<String, dynamic>), key: event.snapshot.key!);
    //     }
    //   });
    // });
    final snapshot = await Amplify.DataStore.query(
      AppTransaction.classType,
      where: AppTransaction.ID.eq(transactionID)
    );

    return snapshot.firstOrNull;
  }

  @override
  Future<void> update({AppTransaction? transaction}) async {
    String uid = await amplifyAuthenticationService.getUserID();
    // DatabaseReference reference = await firebaseRealtimeDatabaseProvider.transactionsReference(uid);
    //
    // Map<String, dynamic> transactionMap = TransactionsHelper().convertTransactionToJson(transaction: transaction!);
    //
    // reference.child(transaction.id!).update(transactionMap);

    if (transaction!.userID == uid) {
      await Amplify.DataStore.save(transaction);
    }
  }

  Future<Stream<QuerySnapshot<AppTransaction>>> getTransactionsByTimePeriod({required DateTime start, required DateTime end}) async {
    List<AppTransaction> list = [];

    String uid = await amplifyAuthenticationService.getUserID();
    TemporalDateTime _start = TemporalDateTime(start);
    TemporalDateTime _end = TemporalDateTime(end);
    // DatabaseReference reference = await firebaseRealtimeDatabaseProvider.transactionsReference(uid);
    //
    // DataSnapshot snapshot =
    // (await reference.orderByChild(DATE_KEY).startAt(start.toIso8601String()).endAt(end.toIso8601String()).once()).snapshot;
    //
    // if (snapshot.value != null) {
    //   Map<dynamic, dynamic> values = snapshot.value as Map<String, dynamic>;
    //   values.forEach((key, value) {
    //     AppTransaction transaction =
    //         TransactionsHelper().convertJsonToTransaction(json: Map<String, dynamic>.from(value), key: key);
    //
    //     list.add(transaction);
    //   });
    // }
    final snapshot = Amplify.DataStore.observeQuery(
        AppTransaction.classType,
        where: AppTransaction.USERID.eq(uid)
            .and(AppTransaction.DATE.between(_start, _end))
    );

    return snapshot;
  }

  Future<List<AppTransaction>> getAllData() async {
    // List<AppTransaction> list = [];
    //
    // String uid = await amplifyAuthenticationService.getUserID();
    // DatabaseReference reference = await firebaseRealtimeDatabaseProvider.transactionsReference(uid);
    //
    // DataSnapshot snapshot = (await reference.once()).snapshot;
    // var values = snapshot.value as Map;
    // values.forEach((key, value) {
    //   AppTransaction transaction =
    //         TransactionsHelper().convertJsonToTransaction(json: Map<String, dynamic>.from(value), key: key);
    //
    //     list.add(transaction);
    //   });
    // return list;

    String uid = await amplifyAuthenticationService.getUserID();
    final snapshot = await Amplify.DataStore.query(
      AppTransaction.classType,
      where: AppTransaction.USERID.eq(uid)
    );
    return snapshot;
  }
}
