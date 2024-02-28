import 'package:equatable/equatable.dart';

class PendingTestModel extends Equatable {
  final String id;
  final String name;
  final String amount;

  const PendingTestModel({
    required this.id,
    required this.name,
    required this.amount,
  });

  factory PendingTestModel.fromJson(Map<String, dynamic> json) {
    return PendingTestModel(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      amount: json["amount"] ?? "",
    );
  }

  factory PendingTestModel.empty() {
    return const PendingTestModel(id: "", name: "", amount: "");
  }

  PendingTestModel copyWith({
    String? id,
    String? name,
    String? amount,
  }) {
    return PendingTestModel(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "amount": amount,
    };
  }

  @override
  List<Object?> get props => [id, name, amount];
}
