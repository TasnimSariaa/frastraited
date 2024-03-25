import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frastraited/screen/service/models/book_apointment_model.dart';
import 'package:frastraited/screen/service/models/collect_reports_model.dart';
import 'package:frastraited/screen/service/models/doctors.dart';
import 'package:frastraited/screen/service/models/donation_model.dart';
import 'package:frastraited/screen/service/models/operationPackages.dart';
import 'package:frastraited/screen/service/models/payment_model.dart';
import 'package:frastraited/screen/service/models/pending_test_model.dart';
import 'package:frastraited/screen/service/models/user_test_model.dart';
import 'package:frastraited/screen/service/models/users.dart';
import 'package:frastraited/screen/service/models/vaccines.dart';
import 'package:frastraited/screen/utils/custom_string_constants.dart';

class DatabaseTables {
  static const users = "users";
  static const doctors = "doctors";
  static const vaccines = "vaccines";
  static const operationPackages = "operationPackages";
  static const pendingTests = "pendingTests";
  static const pendingTestsUser = "pendingTestsUser";
  static const donations = "donations";
  static const collectReports = "collectReports";
  static const bookAppointments = "bookAppointments";
  static const payments = "payments";
}

class DatabaseService {
  DatabaseService._();

  static DatabaseService get instance => DatabaseService._();

  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<List<UsersModel>> getUserList() async {
    List<UsersModel> userList = [];

    await fireStore.collection(DatabaseTables.users).get().then((QuerySnapshot querySnapshot) {
      userList.clear();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        UsersModel user = UsersModel.fromJson(data);
        userList.add(user);
      }
    });

    return userList;
  }

  Future<void> setUserInformation(UsersModel model) async {
    CollectionReference result = fireStore.collection(DatabaseTables.users);

    result.doc(model.userid).set(model.toJson());
  }

  Future<UsersModel> updateUserInformation(UsersModel model) async {
    CollectionReference result = fireStore.collection(DatabaseTables.users);

    result.doc(model.userid).set(model.toJson());

    return model;
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

  Future<void> deletePendingTest(PendingTestModel model) async {
    CollectionReference result = fireStore.collection(DatabaseTables.pendingTests);
    result.doc(model.id).delete();
  }

  Future<void> updatePendingTestInformation(PendingTestModel model) async {
    CollectionReference result = fireStore.collection(DatabaseTables.pendingTests);
    result.doc(model.id).update(model.toJson());
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

  Future<List<BookAppointmentModel>> getUserHistory(UsersModel user) async {
    List<BookAppointmentModel> list = [];

    await fireStore.collection(DatabaseTables.bookAppointments).get().then((QuerySnapshot querySnapshot) {
      list.clear();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        BookAppointmentModel model = BookAppointmentModel.fromJson(data);
        if (model.user.medicalId == user.medicalId) {
          list.add(model);
        }
      }
    });

    return list;
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

  Future<List<UserTestModel>> getUserPendingTest() async {
    List<UserTestModel> userPendingTestList = [];
    final uid = FirebaseAuth.instance.currentUser?.uid ?? "";

    await fireStore.collection(DatabaseTables.pendingTestsUser).get().then((QuerySnapshot querySnapshot) {
      userPendingTestList.clear();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        UserTestModel pendingTest = UserTestModel.fromJson(data);
        if (pendingTest.usersModel.userid == uid) {
          userPendingTestList.add(pendingTest);
        }
      }
    });

    return userPendingTestList;
  }

  Future<void> setPendingTest(UserTestModel model) async {
    CollectionReference result = fireStore.collection(DatabaseTables.pendingTestsUser);
    final pendingTestId = result.doc().id;

    result.doc(pendingTestId).set(model.copyWith(id: pendingTestId).toJson());
  }

  Future<void> addNewTest(PendingTestModel model) async {
    CollectionReference result = fireStore.collection(DatabaseTables.pendingTests);
    final pendingTestId = result.doc().id;

    result.doc(pendingTestId).set(model.copyWith(id: pendingTestId).toJson());
  }

  Future<void> updatePendingTestUserMedicalId(PendingTestModel model) async {
    CollectionReference result = fireStore.collection(DatabaseTables.pendingTestsUser);
    final pendingTestId = result.doc().id;

    result.doc(pendingTestId).update(model.toJson());
  }

  Future<List<DonationModel>> getDonationList() async {
    List<DonationModel> donationList = [];

    await fireStore.collection(DatabaseTables.donations).get().then((QuerySnapshot querySnapshot) {
      donationList.clear();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        DonationModel donation = DonationModel.fromJson(data);
        donationList.add(donation);
      }
    });

    return donationList;
  }

  Future<void> addDonations(DonationModel model) async {
    CollectionReference result = fireStore.collection(DatabaseTables.donations);
    final donationId = result.doc().id;

    result.doc(donationId).set(model.copyWith(id: donationId).toJson());
  }

  Future<void> updateDonations(DonationModel model) async {
    CollectionReference result = fireStore.collection(DatabaseTables.donations);
    result.doc(model.id).update(model.toJson());
  }

  Future<void> deleteDonations(DonationModel model) async {
    CollectionReference result = fireStore.collection(DatabaseTables.donations);
    result.doc(model.id).delete();
  }

  ///Collect reports
  Future<List<CollectReportsModel>> getCollectReportsList() async {
    List<CollectReportsModel> collectReportsList = [];

    await fireStore.collection(DatabaseTables.collectReports).get().then((QuerySnapshot querySnapshot) {
      collectReportsList.clear();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        CollectReportsModel reports = CollectReportsModel.fromJson(data);
        collectReportsList.add(reports);
      }
    });

    return collectReportsList;
  }

  Future<void> addCollectReports(CollectReportsModel model) async {
    CollectionReference result = fireStore.collection(DatabaseTables.collectReports);
    final reportId = result.doc().id;

    result.doc(reportId).set(model.copyWith(id: reportId).toJson());
  }

  Future<List<CollectReportsModel>> getUserCollectReportsList(String medicalId) async {
    List<CollectReportsModel> collectReportsList = [];

    await fireStore.collection(DatabaseTables.collectReports).get().then((QuerySnapshot querySnapshot) {
      collectReportsList.clear();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        CollectReportsModel reports = CollectReportsModel.fromJson(data);
        if (reports.medicalId.toLowerCase() == medicalId.toLowerCase()) {
          collectReportsList.add(reports);
        }
      }
    });

    return collectReportsList;
  }

  ///
  Future<void> addNewAppointment(BookAppointmentModel model, PaymentModel paymentModel) async {
    CollectionReference result = fireStore.collection(DatabaseTables.bookAppointments);
    final appointmentId = result.doc().id;

    result.doc(appointmentId).set(model.copyWith(id: appointmentId).toJson());
    addNewPayment(paymentModel.copyWith(id: appointmentId));
  }

  Future<void> addNewPayment(PaymentModel model) async {
    CollectionReference result = fireStore.collection(DatabaseTables.payments);
    // final paymentId = result.doc().id;

    result.doc(model.id).set(model.toJson());
  }

  Future<List<PaymentModel>> getHistory() async {
    List<PaymentModel> historyList = [];
    final uid = FirebaseAuth.instance.currentUser?.uid ?? "";

    await fireStore.collection(DatabaseTables.payments).get().then((QuerySnapshot querySnapshot) {
      historyList.clear();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        PaymentModel payment = PaymentModel.fromJson(data);
        if (payment.user.userid == uid) {
          historyList.add(payment);
        }
      }
    });

    return historyList;
  }

  Future<List<BookAppointmentModel>> getAdminBookAppointment() async {
    List<BookAppointmentModel> appointmentList = [];

    await fireStore.collection(DatabaseTables.bookAppointments).get().then((QuerySnapshot querySnapshot) {
      appointmentList.clear();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        BookAppointmentModel appointment = BookAppointmentModel.fromJson(data);
        if (CustomStringConstants.appointmentScreen.toLowerCase() == appointment.screenName.toLowerCase()) {
          appointmentList.add(appointment);
        }
      }
    });

    return appointmentList;
  }

  Future<List<BookAppointmentModel>> getAdminNotificationList() async {
    List<String> screens = [
      CustomStringConstants.donationScreen.toLowerCase(),
      CustomStringConstants.pendingTestsScreen.toLowerCase(),
      CustomStringConstants.reportCollectionScreen.toLowerCase(),
    ];
    List<BookAppointmentModel> appointmentList = [];

    await fireStore.collection(DatabaseTables.bookAppointments).get().then((QuerySnapshot querySnapshot) {
      appointmentList.clear();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        BookAppointmentModel appointment = BookAppointmentModel.fromJson(data);
        if (screens.contains(appointment.screenName.toLowerCase())) {
          appointmentList.add(appointment);
        }
      }
    });

    return appointmentList;
  }

  Future<void> updateAppointmentStatus(BookAppointmentModel model) async {
    CollectionReference result = fireStore.collection(DatabaseTables.bookAppointments);
    result.doc(model.id).update(model.toJson());
  }

  Future<void> updatePaymentStatus(String id, String paymentStatus) async {
    CollectionReference result = fireStore.collection(DatabaseTables.payments);
    final docSnapshot = await result.doc(id).get();

    PaymentModel paymentModel = PaymentModel.fromJson(docSnapshot.data() as Map<String, dynamic>);

    result.doc(id).update(paymentModel.copyWith(paymentStatus: paymentStatus).toJson());
  }
}
