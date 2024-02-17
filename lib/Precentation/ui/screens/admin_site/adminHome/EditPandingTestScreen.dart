import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/Precentation/ui/utility/search_field.dart'; // Import the SearchField widget
import 'package:frastraited/screen/widgets/bodyBackground.dart';

class EditPendingTest extends StatefulWidget {
  const EditPendingTest({Key? key}) : super(key: key);

  @override
  State<EditPendingTest> createState() => _EditPendingTestState();
}

class _EditPendingTestState extends State<EditPendingTest> {
  // Sample list of pending tests (replace with actual data)
  List<Map<String, dynamic>> pendingTests = [
    {'name': 'Blood Test', 'amount': 'BDT 200'},
    {'name': 'Urine Test', 'amount': 'BDT 150'},
    {'name': 'X-ray', 'amount': 'BDT 300'},
    {'name': 'MRI', 'amount': 'BDT 500'},
  ];

  // Variable to store patient's medical ID
  String patientMedicalId = '';

  // Controller for search text field
  TextEditingController searchController = TextEditingController();


  // Filtered list of pending tests
  List<Map<String, dynamic>> filteredTests = [];

  @override
  void initState() {
    super.initState();
    filteredTests = pendingTests;
    searchController.addListener(_onSearchChanged);
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
      filteredTests = pendingTests.where((test) {
        String testName = test['name'].toLowerCase();
        return testName.contains(query);
      }).toList();
    });
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
                  SearchField( // Use the SearchField widget
                    controller: searchController,
                    onTextChanged: (value) {
                      setState(() {}); // Trigger rebuild on text change
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'All Tests',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor),
                  ),
                  const SizedBox(height: 40),
                  // Displaying list of pending tests
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: filteredTests.length,
                    itemBuilder: (context, index) {
                      final test = filteredTests[index];
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
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Amount: ${test['amount']}',
                                  style: TextStyle(color: Colors.blueGrey),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _showAddPatientBottomSheet(context);
                              },
                              child: Text(
                                '  Add for Patient ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
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
  void _showAddPatientBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter Patient Medical ID:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter Medical ID',
                ),
                onChanged: (value) {
                  setState(() {
                    patientMedicalId = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _addTestForPatient(context);
                },
                child: Text(
                  'Add',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Function to add test for the patient
  void _addTestForPatient(BuildContext context) {
    // Perform any necessary logic with the patient medical ID
    // For now, let's just print it
    print('Patient Medical ID: $patientMedicalId');

    // Close the bottom sheet
    Navigator.pop(context);
  }
}
