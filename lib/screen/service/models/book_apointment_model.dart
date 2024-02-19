import 'package:frastraited/screen/service/models/users.dart';

class BookAppointmentModel {
  final String id;
  final Map<String, dynamic> doctor;
  final UsersModel user;
  final String currentDateTime;
  final String transactionId;
  final String name;
  final String email;

  BookAppointmentModel({
    required this.id,
    required this.doctor,
    required this.user,
    required this.currentDateTime,
    required this.transactionId,
    required this.name,
    required this.email,
  });

  factory BookAppointmentModel.fromJson(Map<String, dynamic> json) {
    return BookAppointmentModel(
      id: json["id"] ?? "",
      doctor: json["doctor"] ?? {},
      user: json["user"] == null ? UsersModel.empty() : UsersModel.fromJson(json["user"]),
      currentDateTime: json["currentDateTime"] ?? "",
      transactionId: json["transactionId"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
    );
  }

  factory BookAppointmentModel.empty() {
    return BookAppointmentModel(
      id: "",
      doctor: {},
      user: UsersModel.empty(),
      currentDateTime: "",
      transactionId: "",
      name: "",
      email: "",
    );
  }

  BookAppointmentModel copyWith({
    String? id,
    Map<String, dynamic>? doctor,
    UsersModel? user,
    String? currentDateTime,
    String? transactionId,
    String? name,
    String? email,
  }) {
    return BookAppointmentModel(
      id: id ?? this.id,
      doctor: doctor ?? this.doctor,
      user: user ?? this.user,
      currentDateTime: currentDateTime ?? this.currentDateTime,
      transactionId: transactionId ?? this.transactionId,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "doctor": doctor,
      "user": user.toJson(),
      "currentDateTime": currentDateTime,
      "transactionId": transactionId,
      "name": name,
      "email": email,
    };
  }
}
