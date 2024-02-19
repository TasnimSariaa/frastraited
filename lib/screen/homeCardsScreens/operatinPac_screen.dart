import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/Precentation/ui/utility/search_field.dart'; // Import the SearchField widget
import 'package:frastraited/screen/service/database_service.dart';
import 'package:frastraited/screen/service/models/operationPackages.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';

class OperationScreen extends StatefulWidget {
  const OperationScreen({super.key});

  @override
  State<OperationScreen> createState() => _OperationScreenState();
}

class _OperationScreenState extends State<OperationScreen> {
  TextEditingController searchController = TextEditingController();

  List<OperationModel> operationList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getOperationList();
    searchController.addListener(_onSearchChanged);
  }

  void _getOperationList() async {
    operationList.clear();
    final result = await DatabaseService.instance.getOperationInformation();
    operationList.addAll(result);
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
    // setState(() {
    //   filteredOperationPackages = availableOperationPackages.where((package) {
    //     String packageName = package['name'].toLowerCase();
    //     return packageName.contains(query);
    //   }).toList();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyBackground(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : operationList.isEmpty
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
                            const SizedBox(
                              height: 10,
                            ),
                            SearchField(
                              controller: searchController,
                              onTextChanged: (value) {
                                setState(() {}); // Trigger rebuild on text change
                              },
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Available Operations',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 40),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: operationList.length,
                              itemBuilder: (BuildContext context, int index) {
                                final package = operationList[index];
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // Handle onTap event
                                      },
                                      child: Container(
                                        height: 120,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              spreadRadius: 1,
                                              blurRadius: 3,
                                              offset: const Offset(0, 2), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 120,
                                              decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.only(
                                                  topLeft: Radius.circular(8),
                                                  bottomLeft: Radius.circular(8),
                                                ),
                                                image: DecorationImage(
                                                  image: NetworkImage(package.operationImageUrl),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 8),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      package.name,
                                                      style: const TextStyle(fontSize: 18, color: AppColors.primaryColor),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      package.description,
                                                      style: const TextStyle(color: Colors.grey),
                                                    ),
                                                    const SizedBox(
                                                      height: 12,
                                                    ),
                                                    Text(
                                                      'Amount: ${package.amount}',
                                                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
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
