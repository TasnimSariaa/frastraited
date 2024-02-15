import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';

class ReportCollection extends StatefulWidget {
  const ReportCollection({Key? key}) : super(key: key);

  @override
  State<ReportCollection> createState() => _ReportCollectionState();
}

class _ReportCollectionState extends State<ReportCollection> {
  List<Map<String, dynamic>> testReports = [
    {'type': 'Blood Test', 'ready': false, 'approximateTime': '11:00 A.M'},
    {'type': 'Urine Test', 'ready': true}
    // Add more test reports as needed
  ];

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
                        icon: Icon(
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
                  Text(
                    'Report Collection',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 25),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: testReports.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          if (!testReports[index]['ready']) {
                            // Show dialog if report is not ready
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Report Not Available'),
                                  content: Text(
                                    'This report is not ready yet! Might be available at: ${testReports[index]['approximateTime']}',
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Close'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 26),
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Report : ${testReports[index]['type']}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 20),
                              if (testReports[index]['ready'])
                                ElevatedButton(
                                  onPressed: () {
                                    // Implement collect report functionality
                                  },
                                  child: Text('  Collect Report  ',
                                    style: TextStyle(color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              else
                                Text(
                                  'This report is not ready yet! Tap for details.',
                                  style: TextStyle(color: Colors.red),
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
}
