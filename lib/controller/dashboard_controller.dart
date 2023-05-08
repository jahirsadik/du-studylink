import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dustudylink/database/firestore_db.dart';
import 'package:dustudylink/model/resource.dart';

class DashboardController {
  Stream<QuerySnapshot<Resource>> getResourceStream() {
    return FireStoreDB().getResourceStreamDB();
  }
}
