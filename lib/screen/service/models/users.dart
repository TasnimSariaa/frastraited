class UsersModel {
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String userType;
  final String userid;
  final String medicalId;

  UsersModel({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.userType,
    required this.userid,
    required this.medicalId,
  });

  factory UsersModel.fromJson(Map<String, dynamic> json) {
    return UsersModel(
      email: json["email"] ?? "",
      firstName: json["firstName"] ?? "",
      lastName: json["lastName"] ?? "",
      phone: json["phone"] ?? "",
      userType: json["userType"] ?? "",
      userid: json["userid"] ?? "",
      medicalId: json["medicalId"] ?? "",
    );
  }

  factory UsersModel.empty() {
    return UsersModel(
      email: "",
      firstName: "",
      lastName: "",
      phone: "",
      userType: "",
      userid: "",
      medicalId: "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "phone": phone,
      "userType": userType,
      "userid": userid,
      "medicalId": medicalId,
    };
  }
}
