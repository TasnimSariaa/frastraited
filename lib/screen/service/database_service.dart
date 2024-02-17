import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frastraited/screen/service/models/users.dart';

class DatabaseService {
  DatabaseService._();

  static DatabaseService get instance => DatabaseService._();

  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<UsersModel> getUserInfo(String userUid) async {
    CollectionReference result = fireStore.collection('users');

    final docSnapshot = await result.doc(userUid).get();

    UsersModel user = UsersModel.fromJson(docSnapshot.data() as Map<String, dynamic>);

    return user;
  }
}
