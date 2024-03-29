class DonationModel {
  final String id;
  final String name;
  final String age;
  final String wardNumber;
  final String bedNumber;
  final String disease;
  final String imageUrl;
  final String bkashNumber;

  DonationModel({
    required this.id,
    required this.name,
    required this.age,
    required this.wardNumber,
    required this.bedNumber,
    required this.disease,
    required this.imageUrl,
    required this.bkashNumber,
  });

  factory DonationModel.fromJson(Map<String, dynamic> json) {
    return DonationModel(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      age: json["age"] ?? "",
      wardNumber: json["wardNumber"] ?? "",
      bedNumber: json["bedNumber"] ?? "",
      disease: json["disease"] ?? "",
      imageUrl: json["imageUrl"] ?? "",
      bkashNumber: json["bkashNumber"] ?? "",
    );
  }

  factory DonationModel.empty() {
    return DonationModel(
      id: "",
      name: "",
      age: "",
      wardNumber: "",
      bedNumber: "",
      disease: "",
      imageUrl: "",
      bkashNumber: "",
    );
  }

  DonationModel copyWith({
    String? id,
    String? name,
    String? age,
    String? wardNumber,
    String? bedNumber,
    String? disease,
    String? imageUrl,
    String? bkashNumber,
  }) {
    return DonationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      wardNumber: wardNumber ?? this.wardNumber,
      bedNumber: bedNumber ?? this.bedNumber,
      disease: disease ?? this.disease,
      imageUrl: imageUrl ?? this.imageUrl,
      bkashNumber: bkashNumber ?? this.bkashNumber,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "age": age,
      "wardNumber": wardNumber,
      "bedNumber": bedNumber,
      "disease": disease,
      "imageUrl": imageUrl,
      "bkashNumber": bkashNumber,
    };
  }
}
