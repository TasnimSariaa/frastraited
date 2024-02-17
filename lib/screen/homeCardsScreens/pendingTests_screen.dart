import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/screens/Payments_screen.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';

class PendingTests extends StatefulWidget {
  const PendingTests({Key? key}) : super(key: key);

  @override
  State<PendingTests> createState() => _PendingTestsState();
}

class _PendingTestsState extends State<PendingTests> {
  // Sample list of pending tests (replace with actual data)
  List<Map<String, dynamic>> pendingTests = [
    {'name': 'Blood Test', 'amount': 'BDT 200'},
    {'name': 'Urine Test', 'amount': 'BDT 150'},
    {'name': 'X-ray', 'amount': 'BDT 300'},
    {'name': 'MRI', 'amount': 'BDT 500'},
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
                  const SizedBox(height: 20),
                  Text(
                    'Pending Tests',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                  ),
                  const SizedBox(height: 40),
                  // Displaying list of pending tests
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: pendingTests.length,
                    itemBuilder: (context, index) {
                      final test = pendingTests[index];
                      return Container(
                        height: 87,
                        margin: EdgeInsets.only(bottom: 20),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  test['name'],
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Amount: ${test['amount']}',
                                  style: TextStyle(color: Colors.blueGrey),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _bookTest(test['name'], test['amount']);
                              },
                              child: Text(
                                '  Book Test  ',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
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

  void _bookTest(String testName, String amount) {
    // Navigate to PaymentsScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentsScreen(category: 'Test Booking', type: testName, payable: amount),
      ),
    );
  }
}
