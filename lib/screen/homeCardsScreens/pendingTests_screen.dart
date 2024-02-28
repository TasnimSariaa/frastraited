import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/screens/Payments_screen.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/Precentation/ui/widgets/empty_container_view.dart';
import 'package:frastraited/screen/service/database_service.dart';
import 'package:frastraited/screen/service/models/user_test_model.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';

class PendingTests extends StatefulWidget {
  const PendingTests({super.key});

  @override
  State<PendingTests> createState() => _PendingTestsState();
}

class _PendingTestsState extends State<PendingTests> {
  List<UserTestModel> pendingTestList = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getPendingTestList();
  }

  void _getPendingTestList() async {
    final result = await DatabaseService.instance.getUserPendingTest();
    pendingTestList.clear();
    pendingTestList.addAll(result);
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                const SizedBox(height: 20),
                const Text(
                  'Pending Tests',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                ),
                const SizedBox(height: 40),
                // Displaying list of pending tests
                _view,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get _view {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (pendingTestList.isEmpty) {
      return const Center(child: EmptyContainerView());
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: pendingTestList.length,
        itemBuilder: (context, index) {
          final test = pendingTestList[index];
          return Container(
            height: 87,
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
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
                      test.pendingTestModel.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Amount: ${test.pendingTestModel.amount}',
                      style: const TextStyle(color: Colors.blueGrey),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    _bookTest(test.pendingTestModel.name, test.pendingTestModel.amount);
                  },
                  child: const Text(
                    '  Book Test  ',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
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
