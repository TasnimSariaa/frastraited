class UsersModel {
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String userType;
  final String userid;
  final String medicalId;
  final String profileUrl;

  UsersModel({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.userType,
    required this.userid,
    required this.medicalId,
    required this.profileUrl,
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
      profileUrl: json["profileUrl"] ?? "",
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
      profileUrl: "",
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
      "profileUrl": profileUrl,
    };
  }

  UsersModel copyWith({
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    String? userType,
    String? userid,
    String? medicalId,
    String? profileUrl,
  }) {
    return UsersModel(
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      userType: userType ?? this.userType,
      userid: userid ?? this.userid,
      medicalId: medicalId ?? this.medicalId,
      profileUrl: profileUrl ?? this.profileUrl,
    );
  }
}
