import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/screens/Payments_screen.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/Precentation/ui/widgets/empty_container_view.dart';
import 'package:frastraited/screen/service/database_service.dart';
import 'package:frastraited/screen/service/models/collect_reports_model.dart';
import 'package:frastraited/screen/utils/custom_string_constants.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';

class ReportCollection extends StatefulWidget {
  const ReportCollection({super.key});

  @override
  State<ReportCollection> createState() => _ReportCollectionState();
}

class _ReportCollectionState extends State<ReportCollection> {
  List<CollectReportsModel> collectReportList = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      _getUser(FirebaseAuth.instance.currentUser!.uid);
    }
  }

  void _getUser(String uid) async {
    final user = await DatabaseService.instance.getUserInfo(uid);
    _getCollectReportList("${user.firstName} (${user.medicalId})");
  }

  void _getCollectReportList(String medicalId) async {
    collectReportList.clear();
    final result = await DatabaseService.instance.getUserCollectReportsList(medicalId);
    collectReportList.addAll(result);
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyBackground(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : collectReportList.isEmpty
                ? const Center(child: EmptyContainerView())
                : SafeArea(
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
                            const SizedBox(height: 30),
                            const Text(
                              'Report Collection',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                            ),
                            const SizedBox(height: 25),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: collectReportList.length,
                              itemBuilder: (context, index) {
                                final item = collectReportList[index];
                                return GestureDetector(
                                  onTap: () {
                                    // if (collectReportList[index].reportList.isEmpty) {
                                    //   // Show dialog if report is not ready
                                    //   showDialog(
                                    //     context: context,
                                    //     builder: (context) {
                                    //       return AlertDialog(
                                    //         title: const Text('Report Not Available'),
                                    //         content: Text(
                                    //           'This report is not ready yet! Might be available at: ${testReports[index]['approximateTime']}',
                                    //         ),
                                    //         actions: <Widget>[
                                    //           TextButton(
                                    //             onPressed: () {
                                    //               Navigator.of(context).pop();
                                    //             },
                                    //             child: const Text('Close'),
                                    //           ),
                                    //         ],
                                    //       );
                                    //     },
                                    //   );
                                    // } else {
                                    //   _collectReport(testReports[index]['type'], testReports[index]['payable']);
                                    // }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 26),
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Report : ${item.reportList.isEmpty ? "" : item.reportList.first.reportName}',
                                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 20),
                                        if (item.isReady)
                                          ElevatedButton(
                                            onPressed: () {
                                              // _collectReport(testReports[index]['type'], testReports[index]['payable']);
                                            },
                                            child: const Text(
                                              '  Collect Report  ',
                                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                                            ),
                                          )
                                        else
                                          const Text(
                                            'This report is not ready yet! Tap for details.',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        const SizedBox(height: 10),
                                        Text(
                                          'Payable: ${item.payable}',
                                          style: const TextStyle(color: Colors.blueGrey),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }

  void _collectReport(String type, String payable) {
    // Navigate to PaymentsScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentsScreen(
          category: 'Test Report',
          type: type,
          payable: payable,
          screenName: CustomStringConstants.reportCollectionScreen,
        ),
      ),
    );
  }
}
