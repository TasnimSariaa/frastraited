class CollectReportsModel {
  final String id;
  final String medicalId;
  final List<ReportInfoModel> reportList;

  CollectReportsModel({
    required this.id,
    required this.medicalId,
    required this.reportList,
  });

  factory CollectReportsModel.fromJson(Map<String, dynamic> json) {
    return CollectReportsModel(
      id: json["id"] ?? "",
      medicalId: json["medicalId"] ?? "",
      reportList: json["reportList"] == null
          ? []
          : List<ReportInfoModel>.from(
              json["reportList"].map((x) => ReportInfoModel.fromJson(x)),
            ),
    );
  }

  factory CollectReportsModel.empty() {
    return CollectReportsModel(
      id: "",
      medicalId: "",
      reportList: [],
    );
  }

  CollectReportsModel copyWith({
    String? id,
    String? medicalId,
    List<ReportInfoModel>? reportList,
  }) {
    return CollectReportsModel(
      id: id ?? this.id,
      medicalId: medicalId ?? this.medicalId,
      reportList: reportList ?? this.reportList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "medicalId": medicalId,
      "reportList": reportList.map((e) => e.toJson()),
    };
  }
}

class ReportInfoModel {
  final String reportName;
  final String reportUrl;

  ReportInfoModel({
    required this.reportName,
    required this.reportUrl,
  });

  factory ReportInfoModel.fromJson(Map<String, dynamic> json) {
    return ReportInfoModel(
      reportName: json["reportName"] ?? "",
      reportUrl: json["reportUrl"] ?? "",
    );
  }

  factory ReportInfoModel.empty() {
    return ReportInfoModel(reportName: "", reportUrl: "");
  }

  ReportInfoModel copyWith({
    String? reportName,
    String? reportUrl,
  }) {
    return ReportInfoModel(
      reportName: reportName ?? this.reportName,
      reportUrl: reportUrl ?? this.reportUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "reportName": reportName,
      "reportUrl": reportUrl,
    };
  }
}
