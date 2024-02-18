class VaccineModel {
  final String id;
  final String name;
  final String place;
  final String vaccineImageUrl;
  final String price;

  VaccineModel({
    required this.id,
    required this.name,
    required this.price,
    required this.place,
    required this.vaccineImageUrl
  });


  factory VaccineModel.fromJson(Map<String, dynamic> json) {
    return VaccineModel(
        id: json['id'] ?? "",
        name: json['name'] ?? "",
        price: json["price"] ?? "",
        place: json['place'] ?? "",
        vaccineImageUrl: json['vaccineImageUrl'] ?? "",
    );
}

  factory VaccineModel.empty() {
    return VaccineModel(
      id: "",
      name: "",
       price: "",
      place: "",
      vaccineImageUrl: ""
    );
  }

  VaccineModel copyWith({
    String? id,
    String? name,
    String? price,
    String? vaccineImageUrl,
    String? place
  }) {
    return VaccineModel(
         id: id ?? this.id,
        name: name ?? this.name,
        price: price ?? this.price,
        place: place ?? this.place,
        vaccineImageUrl: vaccineImageUrl ?? this.vaccineImageUrl
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id" : id,
      "name": name,
       "place" :place,
      "price" :price,
      "vaccineImageUrl" : vaccineImageUrl
    };
  }

}