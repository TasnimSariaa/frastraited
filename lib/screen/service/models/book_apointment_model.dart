import 'package:frastraited/screen/service/models/users.dart';

class BookAppointmentModel {
  final String id;
  final Map<String, dynamic> doctor;
  final Map<String, dynamic> donationUser;
  final UsersModel user;
  final String currentDateTime;
  final String transactionId;
  final String name;
  final String email;
  final String status;
  final String screenName;
  final String paymentCategory;

  BookAppointmentModel({
    required this.id,
    required this.doctor,
    required this.donationUser,
    required this.user,
    required this.currentDateTime,
    required this.transactionId,
    required this.name,
    required this.status,
    required this.email,
    required this.screenName,
    required this.paymentCategory,
  });

  factory BookAppointmentModel.fromJson(Map<String, dynamic> json) {
    return BookAppointmentModel(
      id: json["id"] ?? "",
      doctor: json["doctor"] ?? {},
      donationUser: json["donationUser"] ?? {},
      user: json["user"] == null ? UsersModel.empty() : UsersModel.fromJson(json["user"]),
      currentDateTime: json["currentDateTime"] ?? "",
      transactionId: json["transactionId"] ?? "",
      name: json["name"] ?? "",
      status: json["status"] ?? "",
      email: json["email"] ?? "",
      screenName: json["screenName"] ?? "",
      paymentCategory: json["paymentCategory"] ?? "",
    );
  }

  factory BookAppointmentModel.empty() {
    return BookAppointmentModel(
      id: "",
      doctor: {},
      donationUser: {},
      user: UsersModel.empty(),
      currentDateTime: "",
      transactionId: "",
      name: "",
      email: "",
      status: "",
      screenName: "",
      paymentCategory: "",
    );
  }

  BookAppointmentModel copyWith({
    String? id,
    Map<String, dynamic>? doctor,
    Map<String, dynamic>? donationUser,
    UsersModel? user,
    String? currentDateTime,
    String? transactionId,
    String? name,
    String? email,
    String? status,
    String? screenName,
    String? paymentCategory,
  }) {
    return BookAppointmentModel(
      id: id ?? this.id,
      doctor: doctor ?? this.doctor,
      donationUser: donationUser ?? this.donationUser,
      user: user ?? this.user,
      currentDateTime: currentDateTime ?? this.currentDateTime,
      transactionId: transactionId ?? this.transactionId,
      name: name ?? this.name,
      email: email ?? this.email,
      status: status ?? this.status,
      screenName: screenName ?? this.screenName,
      paymentCategory: paymentCategory ?? this.paymentCategory,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "doctor": doctor,
      "donationUser": donationUser,
      "user": user.toJson(),
      "currentDateTime": currentDateTime,
      "transactionId": transactionId,
      "name": name,
      "email": email,
      "status": status,
      "screenName": screenName,
      "paymentCategory": paymentCategory,
    };
  }
}
