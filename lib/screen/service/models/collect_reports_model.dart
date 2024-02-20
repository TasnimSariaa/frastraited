class CollectReportsModel {
  final String id;
  final String medicalId;
  final bool isReady;
  final String payable;
  final List<ReportInfoModel> reportList;

  CollectReportsModel({
    required this.id,
    required this.isReady,
    required this.medicalId,
    required this.payable,
    required this.reportList,
  });

  factory CollectReportsModel.fromJson(Map<String, dynamic> json) {
    return CollectReportsModel(
      id: json["id"] ?? "",
      isReady: json["isReady"] ?? "",
      medicalId: json["medicalId"] ?? "",
      payable: json["payable"] ?? "",
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
      isReady: true,
      medicalId: "",
      payable: "",
      reportList: [],
    );
  }

  CollectReportsModel copyWith({
    String? id,
    bool? isReady,
    String? medicalId,
    String? payable,
    List<ReportInfoModel>? reportList,
  }) {
    return CollectReportsModel(
      id: id ?? this.id,
      isReady: isReady ?? this.isReady,
      medicalId: medicalId ?? this.medicalId,
      payable: payable ?? this.payable,
      reportList: reportList ?? this.reportList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "isReady": isReady,
      "medicalId": medicalId,
      "payable": payable,
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
