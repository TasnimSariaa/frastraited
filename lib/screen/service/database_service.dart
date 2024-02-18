import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frastraited/screen/service/models/doctors.dart';
import 'package:frastraited/screen/service/models/users.dart';

class DatabaseTables {
  static const users = "users";
  static const doctors = "doctors";
}

class DatabaseService {
  DatabaseService._();

  static DatabaseService get instance => DatabaseService._();

  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<void> setUserInformation(UsersModel model) async {
    CollectionReference result = fireStore.collection(DatabaseTables.users);

    result.doc(model.userid).set(model.toJson());
  }

  Future<UsersModel> getUserInfo(String userUid) async {
    CollectionReference result = fireStore.collection(DatabaseTables.users);

    final docSnapshot = await result.doc(userUid).get();

    UsersModel user = UsersModel.fromJson(docSnapshot.data() as Map<String, dynamic>);

    return user;
  }

  Future<void> setDoctorInformation(DoctorModel model) async {
    CollectionReference result = fireStore.collection(DatabaseTables.doctors);
    final docId = result.doc().id;

    result.doc(docId).set(model.copyWith(id: docId).toJson());
  }

  Future<void> deleteDoctor(DoctorModel model) async {
    CollectionReference result = fireStore.collection(DatabaseTables.doctors);
    result.doc(model.id).delete();
  }

  Future<void> updateDoctorInformation(DoctorModel model) async {
    CollectionReference result = fireStore.collection(DatabaseTables.doctors);
    result.doc(model.id).update(model.toJson());
  }

  Future<List<DoctorModel>> getDoctorInformation() async {
    List<DoctorModel> doctorsList = [];

    await fireStore.collection(DatabaseTables.doctors).get().then((QuerySnapshot querySnapshot) {
      doctorsList.clear();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        DoctorModel doctor = DoctorModel.fromJson(data);
        doctorsList.add(doctor);
      }
    });

    return doctorsList;
  }
}
