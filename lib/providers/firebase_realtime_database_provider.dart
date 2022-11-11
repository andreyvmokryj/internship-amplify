import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';

class FirebaseRealtimeDatabaseProvider {
  FirebaseRealtimeDatabaseProvider({@required this.database}) {
    databaseReference = database.ref();
    print("FirebaseRealtimeDatabaseProvider.FirebaseRealtimeDatabaseProvider: ${database.databaseURL}");
  }

  final FirebaseDatabase database;

  DatabaseReference databaseReference;

  final String TRANSACTIONS_NODE = 'transactions';

  Future<DatabaseReference> transactionsReference(String userID) async {
    DatabaseReference transactionsReference = databaseReference.child(TRANSACTIONS_NODE).child(userID);
    return transactionsReference;
  }

  Future<FirebaseStreamsGroup> transactionStreams(String userID) async {
    print("FirebaseRealtimeDatabaseProvider.transactionStreams: $userID");

    DatabaseReference reference = await transactionsReference(userID);

    return FirebaseStreamsGroup(
        onChildAdded: reference.onChildAdded,
        onChildChanged: reference.onChildChanged,
        onChildDeleted: reference.onChildRemoved);
  }

}

class FirebaseStreamsGroup {
  Stream<DatabaseEvent> onChildAdded;
  Stream<DatabaseEvent> onChildDeleted;
  Stream<DatabaseEvent> onChildChanged;

  FirebaseStreamsGroup({@required this.onChildAdded, @required this.onChildChanged, @required this.onChildDeleted});
}
