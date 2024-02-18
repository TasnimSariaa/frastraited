class OperationModel {
  final String id;
  final String name;
  final String description;
  final String operationImageUrl;
  final String amount;

  OperationModel({
    required this.id,
    required this.name,
    required this.description,
    required this.amount,
    required this.operationImageUrl
  });

  factory OperationModel.fromJson(Map<String, dynamic> json) {
    return OperationModel(
        id: json['id'] ?? "",
        name: json['name'] ?? "",
        description:json['description'] ?? "",
        amount: json['amount'] ?? "",
        operationImageUrl: json['operationImageUrl'] ?? ""
    );

  }

  factory OperationModel.empty() {
    return OperationModel(
        id: "",
        name: "",
        description: "",
       amount: "",
      operationImageUrl: "",
    );
  }


  OperationModel copyWith({
    String? id,
    String? name,
    String? amount,
    String? operationImageUrl,
    String? description
  }) {
    return OperationModel(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        amount: amount ?? this.amount,
        operationImageUrl: operationImageUrl ?? this.operationImageUrl

    );
  }

    Map<String, dynamic> toJson() {
      return {
        "id" : id,
        "name": name,
        "amount": amount,
        "description" : description,
        "operationImageUrl" : operationImageUrl
      };
    }

  }

