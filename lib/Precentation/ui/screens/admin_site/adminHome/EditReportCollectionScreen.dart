import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/screen/service/database_service.dart';
import 'package:frastraited/screen/service/models/collect_reports_model.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';

class EditReportCollection extends StatefulWidget {
  const EditReportCollection({super.key});

  @override
  State<EditReportCollection> createState() => _EditReportCollectionState();
}

class _EditReportCollectionState extends State<EditReportCollection> {
  List<CollectReportsModel> collectReportList = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCollectReportList();
  }

  void _getCollectReportList() async {
    collectReportList.clear();
    final result = await DatabaseService.instance.getCollectReportsList();
    collectReportList.addAll(result);
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppColors.primaryColor,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Upload Reports',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _showUploadReportBottomSheet(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                    ),
                    child: const Text(
                      '   Upload Report  ',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ..._listView,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> get _listView {
    if (isLoading) {
      return [const Center(child: CircularProgressIndicator())];
    }
    if (collectReportList.isEmpty) {
      return [const Center(child: Text("List is Empty"))];
    }
    return List.generate(collectReportList.length, (index) {
      final report = collectReportList[index];
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Medical Id: ${report.medicalId}"),
            const SizedBox(height: 10),
            Wrap(
              runSpacing: 10,
              spacing: 10,
              children: List.generate(
                report.reportList.length,
                (innerIndex) {
                  final item = report.reportList[innerIndex];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.picture_as_pdf, size: 40),
                      const SizedBox(height: 10),
                      Text(item.reportName),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  void _showUploadReportBottomSheet(BuildContext context) {
    TextEditingController medicalIdController = TextEditingController();
    TextEditingController testNameController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: medicalIdController,
                    decoration: const InputDecoration(labelText: 'Medical ID'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: testNameController,
                    decoration: const InputDecoration(labelText: 'Name of the Test'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Handle the action for uploading report file
                      // You can access the entered medical ID and test name via medicalIdController.text and testNameController.text respectively
                      Navigator.pop(context); // Close the bottom sheet
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Icon(
                            Icons.upload_rounded,
                            color: Colors.white,
                          ),
                          Text(
                            ' Upload Report File ',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final medicalId = medicalIdController.text;
                      final testName = testNameController.text;
                      CollectReportsModel model = CollectReportsModel(
                        id: "",
                        medicalId: medicalId,
                        reportList: [
                          ReportInfoModel(reportName: testName, reportUrl: "url"),
                          ReportInfoModel(reportName: testName, reportUrl: "2url"),
                        ],
                      );
                      await DatabaseService.instance.addCollectReports(model);
                      _getCollectReportList();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
