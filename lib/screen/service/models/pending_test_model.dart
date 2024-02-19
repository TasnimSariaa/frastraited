class PendingTestModel {
  final String id;
  final String name;
  final String amount;
  final String medicalId;

  PendingTestModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.medicalId,
  });

  factory PendingTestModel.fromJson(Map<String, dynamic> json) {
    return PendingTestModel(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      amount: json["amount"] ?? "",
      medicalId: json["medicalId"] ?? "",
    );
  }

  factory PendingTestModel.empty() {
    return PendingTestModel(id: "", name: "", amount: "", medicalId: "");
  }

  PendingTestModel copyWith({
    String? id,
    String? name,
    String? amount,
    String? medicalId,
  }) {
    return PendingTestModel(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      medicalId: medicalId ?? this.medicalId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "amount": amount,
      "medicalId": medicalId,
    };
  }
}
