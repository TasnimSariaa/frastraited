import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/Precentation/ui/utility/search_field.dart'; // Import the SearchField widget
import 'package:frastraited/screen/service/database_service.dart';
import 'package:frastraited/screen/service/models/pending_test_model.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';

class EditPendingTest extends StatefulWidget {
  const EditPendingTest({super.key});

  @override
  State<EditPendingTest> createState() => _EditPendingTestState();
}

class _EditPendingTestState extends State<EditPendingTest> {
  // Controller for search text field
  TextEditingController searchController = TextEditingController();

  List<PendingTestModel> pendingTestList = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // filteredTests = pendingTests;
    searchController.addListener(_onSearchChanged);
    _getPendingTestList();
  }

  void _getPendingTestList() async {
    pendingTestList.clear();
    final result = await DatabaseService.instance.getPendingTest();
    pendingTestList.addAll(result);
    isLoading = false;
    setState(() {});
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Function to handle changes in the search text field
  void _onSearchChanged() {
    String query = searchController.text.toLowerCase();
    setState(() {
      // filteredTests = pendingTests.where((test) {
      //   String testName = test['name'].toLowerCase();
      //   return testName.contains(query);
      // }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyBackground(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : pendingTestList.isEmpty
                ? const Center(child: Text("List is Empty"))
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
                            const SizedBox(height: 20),
                            const Text(
                              'All Tests',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 20),
                            SearchField(
                              // Use the SearchField widget
                              controller: searchController,
                              onTextChanged: (value) {
                                setState(() {}); // Trigger rebuild on text change
                              },
                            ),
                            const SizedBox(height: 40),
                            // Displaying list of pending tests
                            ListView.builder(
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
                                            test.name,
                                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            'Amount: ${test.amount}',
                                            style: const TextStyle(color: Colors.blueGrey),
                                          ),
                                        ],
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          _showAddPatientBottomSheet(context, test);
                                        },
                                        child: const Text(
                                          '  Add for Patient ',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
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

  // Function to show the bottom sheet for adding patient
  void _showAddPatientBottomSheet(BuildContext context, PendingTestModel test) {
    TextEditingController editingController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enter Patient Medical ID:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: editingController,
                  decoration: const InputDecoration(
                    hintText: 'Enter Medical ID',
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Field is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final isValid = formKey.currentState?.validate() ?? false;
                    if (!isValid) return;

                    final medicalId = editingController.text;
                    await DatabaseService.instance.setPendingTest(test.copyWith(medicalId: medicalId));
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
        );
      },
    );
  }
}
