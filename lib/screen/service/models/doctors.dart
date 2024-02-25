class DoctorModel {
  final String id;
  final String name;
  final String speciality;
  final String visitingFee;
  final String profileImageUrl;
  final bool isActive;

  DoctorModel({
    required this.id,
    required this.name,
    required this.speciality,
    required this.visitingFee,
    required this.profileImageUrl,
    required this.isActive,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      speciality: json["speciality"] ?? "",
      visitingFee: json["visitingFee"] ?? "",
      profileImageUrl: json["profileImageUrl"] ?? "",
      isActive: json["isActive"] ?? "",
    );
  }

  factory DoctorModel.empty() {
    return DoctorModel(
      id: "",
      name: "",
      speciality: "",
      visitingFee: "",
      profileImageUrl: "",
      isActive: false,
    );
  }

  DoctorModel copyWith({
    String? id,
    String? name,
    String? speciality,
    String? visitingFee,
    String? profileImageUrl,
    bool? isActive,
  }) {
    return DoctorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      speciality: speciality ?? this.speciality,
      visitingFee: visitingFee ?? this.visitingFee,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "speciality": speciality,
      "visitingFee": visitingFee,
      "profileImageUrl": profileImageUrl,
      "isActive": isActive,
    };
  }
}
