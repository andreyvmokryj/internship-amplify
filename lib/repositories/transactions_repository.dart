import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';
import 'package:radency_internship_project_2/models/transactions/transaction.dart';
import 'package:radency_internship_project_2/models/transactions/transactions_helper.dart';
import 'package:radency_internship_project_2/providers/firebase_auth_service.dart';
import 'package:radency_internship_project_2/providers/firebase_realtime_database_provider.dart';
import 'package:radency_internship_project_2/repositories/repository.dart';

class TransactionsRepository extends IRepository<Transaction> {
  TransactionsRepository(
      {@required this.firebaseRealtimeDatabaseProvider, @required this.firebaseAuthenticationService});

  final FirebaseRealtimeDatabaseProvider firebaseRealtimeDatabaseProvider;
  final FirebaseAuthenticationService firebaseAuthenticationService;

  @override
  Future<void> add(Transaction transaction) async {
    String uid = await firebaseAuthenticationService.getUserID();
    await firebaseRealtimeDatabaseProvider.transactionsReference(uid).then((reference) async {
      Map<String, dynamic> transactionMap = TransactionsHelper().convertTransactionToJson(transaction: transaction);
      await reference.push().set(transactionMap);
    });
  }

  @override
  Future<void> delete({@required String transactionID}) async {
    String uid = await firebaseAuthenticationService.getUserID();
    await firebaseRealtimeDatabaseProvider.transactionsReference(uid).then((reference) async {
      await reference.child(transactionID).remove();
    });
  }

  @override
  Future<Transaction> find({@required String transactionID}) async {
    Transaction transaction;

    String uid = await firebaseAuthenticationService.getUserID();
    await firebaseRealtimeDatabaseProvider.transactionsReference(uid).then((reference) async {
      await reference.child(transactionID).once().then((snapshot) async {
        if (snapshot.value != null) {
          transaction = TransactionsHelper()
              .convertJsonToTransaction(json: Map<String, dynamic>.from(snapshot.value), key: snapshot.key);
        }
      });
    });

    return transaction;
  }

  @override
  Future<void> update({Transaction transaction}) async {
    String uid = await firebaseAuthenticationService.getUserID();
    DatabaseReference reference = await firebaseRealtimeDatabaseProvider.transactionsReference(uid);

    Map<String, dynamic> transactionMap = TransactionsHelper().convertTransactionToJson(transaction: transaction);

    reference.child(transaction.id).update(transactionMap);
  }

  Future<List<Transaction>> getTransactionsByTimePeriod({@required DateTime start, @required DateTime end}) async {
    List<Transaction> list = [];

    String uid = await firebaseAuthenticationService.getUserID();
    DatabaseReference reference = await firebaseRealtimeDatabaseProvider.transactionsReference(uid);

    DataSnapshot snapshot =
        await reference.orderByChild(DATE_KEY).startAt(start.toIso8601String()).endAt(end.toIso8601String()).once();

    if (snapshot.value != null) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, value) {
        Transaction transaction =
            TransactionsHelper().convertJsonToTransaction(json: Map<String, dynamic>.from(value), key: key);

        list.add(transaction);
      });
    }

    return list;
  }

  Future<List<Transaction>> getAllData() async {
    List<Transaction> list = [];

    String uid = await firebaseAuthenticationService.getUserID();
    DatabaseReference reference = await firebaseRealtimeDatabaseProvider.transactionsReference(uid);

    DataSnapshot snapshot = await reference.once();
    var values = snapshot.value;
    values.forEach((key, value) {
        Transaction transaction =
            TransactionsHelper().convertJsonToTransaction(json: Map<String, dynamic>.from(value), key: key);

        list.add(transaction);
      });
    return list;
  }
}
