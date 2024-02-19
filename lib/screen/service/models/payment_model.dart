import 'package:frastraited/screen/service/models/users.dart';

class PaymentModel {
  final String id;
  final UsersModel user;
  final String paymentCategory;
  final String paymentAmount;
  final String paymentStatus;
  final String currentDateTime;

  PaymentModel({
    required this.id,
    required this.user,
    required this.paymentCategory,
    required this.paymentAmount,
    required this.paymentStatus,
    required this.currentDateTime,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json["id"] ?? "",
      user: json["user"] == null ? UsersModel.empty() : UsersModel.fromJson(json["user"]),
      paymentCategory: json["paymentCategory"] ?? "",
      paymentAmount: json["paymentAmount"] ?? "",
      paymentStatus: json["paymentStatus"] ?? "",
      currentDateTime: json["currentDateTime"] ?? "",
    );
  }

  factory PaymentModel.empty() {
    return PaymentModel(
      id: "",
      user: UsersModel.empty(),
      paymentCategory: "",
      paymentAmount: "",
      paymentStatus: "",
      currentDateTime: "",
    );
  }

  PaymentModel copyWith({
    String? id,
    UsersModel? user,
    String? paymentCategory,
    String? paymentAmount,
    String? paymentStatus,
    String? currentDateTime,
  }) {
    return PaymentModel(
      id: id ?? this.id,
      user: user ?? this.user,
      paymentCategory: paymentCategory ?? this.paymentCategory,
      paymentAmount: paymentAmount ?? this.paymentAmount,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      currentDateTime: currentDateTime ?? this.currentDateTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user": user.toJson(),
      "paymentCategory": paymentCategory,
      "paymentAmount": paymentAmount,
      "paymentStatus": paymentStatus,
      "currentDateTime": currentDateTime,
    };
  }
}
