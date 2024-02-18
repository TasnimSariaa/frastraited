import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frastraited/screen/service/models/doctors.dart';
import 'package:frastraited/screen/service/models/operationPackages.dart';
import 'package:frastraited/screen/service/models/pending_test_model.dart';
import 'package:frastraited/screen/service/models/users.dart';
import 'package:frastraited/screen/service/models/vaccines.dart';

class DatabaseTables {
  static const users = "users";
  static const doctors = "doctors";
  static const vaccines = "vaccines";
  static const operationPackages = "operationPackages";
  static const pendingTests = "pendingTests";
  static const pendingTestsUser = "pendingTestsUser";
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

  //For Active Doctor

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

  //For Vaccine

  Future<void> setVaccineInformation(VaccineModel model) async {
    CollectionReference result = fireStore.collection(DatabaseTables.vaccines);
    final vaccineId = result.doc().id;

    result.doc(vaccineId).set(model.copyWith(id: vaccineId).toJson());
  }

  Future<void> deleteVaccine(VaccineModel model) async {
    CollectionReference result = fireStore.collection(DatabaseTables.vaccines);
    result.doc(model.id).delete();
  }

  Future<void> updateVaccineInformation(VaccineModel model) async {
    CollectionReference result = fireStore.collection(DatabaseTables.vaccines);
    result.doc(model.id).update(model.toJson());
  }

  Future<List<VaccineModel>> getVaccineInformation() async {
    List<VaccineModel> vaccineList = [];

    await fireStore.collection(DatabaseTables.vaccines).get().then((QuerySnapshot querySnapshot) {
      vaccineList.clear();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        VaccineModel vaccine = VaccineModel.fromJson(data);
        vaccineList.add(vaccine);
      }
    });

    return vaccineList;
  }

  //For Operation

  Future<void> setOperationInformation(OperationModel model) async {
    CollectionReference result = fireStore.collection(DatabaseTables.operationPackages);
    final operaId = result.doc().id;

    result.doc(operaId).set(model.copyWith(id: operaId).toJson());
  }

  Future<void> deleteOperation(OperationModel model) async {
    CollectionReference result = fireStore.collection(DatabaseTables.operationPackages);
    result.doc(model.id).delete();
  }

  Future<void> updateOperationInformation(OperationModel model) async {
    CollectionReference result = fireStore.collection(DatabaseTables.operationPackages);
    result.doc(model.id).update(model.toJson());
  }

  Future<List<OperationModel>> getOperationInformation() async {
    List<OperationModel> operationList = [];

    await fireStore.collection(DatabaseTables.operationPackages).get().then((QuerySnapshot querySnapshot) {
      operationList.clear();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        OperationModel operation = OperationModel.fromJson(data);
        operationList.add(operation);
      }
    });

    return operationList;
  }

  Future<List<PendingTestModel>> getPendingTest() async {
    List<PendingTestModel> pendingTestList = [];

    await fireStore.collection(DatabaseTables.pendingTests).get().then((QuerySnapshot querySnapshot) {
      pendingTestList.clear();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        PendingTestModel pendingTest = PendingTestModel.fromJson(data);
        pendingTestList.add(pendingTest);
      }
    });

    return pendingTestList;
  }

  Future<void> setPendingTest(PendingTestModel model) async {
    CollectionReference result = fireStore.collection(DatabaseTables.pendingTestsUser);
    final pendingTestId = result.doc().id;

    result.doc(pendingTestId).set(model.copyWith(id: pendingTestId).toJson());
  }

  Future<void> updatePendingTestUserMedicalId(PendingTestModel model) async {
    CollectionReference result = fireStore.collection(DatabaseTables.pendingTestsUser);
    final pendingTestId = result.doc().id;

    result.doc(pendingTestId).update(model.toJson());
  }
}
