import 'package:equatable/equatable.dart';
import 'package:frastraited/screen/service/models/pending_test_model.dart';
import 'package:frastraited/screen/service/models/users.dart';

class UserTestModel extends Equatable {
  final String id;
  final String medicalId;
  final UsersModel usersModel;
  final PendingTestModel pendingTestModel;

  const UserTestModel({
    required this.id,
    required this.medicalId,
    required this.usersModel,
    required this.pendingTestModel,
  });

  factory UserTestModel.fromJson(Map<String, dynamic> json) {
    return UserTestModel(
      id: json["id"] ?? "",
      medicalId: json["medicalId"] ?? "",
      usersModel: json["usersModel"] ?? UsersModel.empty(),
      pendingTestModel: json["pendingTestModel"] ?? PendingTestModel.empty(),
    );
  }

  factory UserTestModel.empty() {
    return UserTestModel(
      id: "",
      medicalId: "",
      usersModel: UsersModel.empty(),
      pendingTestModel: PendingTestModel.empty(),
    );
  }

  UserTestModel copyWith({
    String? id,
    String? medicalId,
    UsersModel? usersModel,
    PendingTestModel? pendingTestModel,
  }) {
    return UserTestModel(
      id: id ?? this.id,
      medicalId: medicalId ?? this.medicalId,
      usersModel: usersModel ?? this.usersModel,
      pendingTestModel: pendingTestModel ?? this.pendingTestModel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "medicalId": medicalId,
      "usersModel": usersModel.toJson(),
      "pendingTestModel": pendingTestModel.toJson(),
    };
  }

  @override
  List<Object?> get props => [id, medicalId, usersModel, pendingTestModel];
}
