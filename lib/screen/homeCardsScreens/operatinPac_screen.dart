import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/Precentation/ui/utility/search_field.dart'; // Import the SearchField widget
import 'package:frastraited/screen/widgets/bodyBackground.dart';

class OperationScreen extends StatefulWidget {
  const OperationScreen({Key? key}) : super(key: key);

  @override
  State<OperationScreen> createState() => _OperationScreenState();
}

class _OperationScreenState extends State<OperationScreen> {
  // Sample list of available operation packages
  final List<Map<String, dynamic>> availableOperationPackages = [
    {
      'name': 'Heart Surgery',
      'description': 'Heart operation package',
      'imageUrl': 'https://example.com/heart_surgery.jpg',
      'amount': 'BDT 10000',
    },
    {
      'name': 'Brain Surgery',
      'description': 'Brain operation package',
      'imageUrl': 'https://example.com/brain_surgery.jpg',
      'amount': 'BDT 15000',
    },
    {
      'name': 'Knee Replacement',
      'description': 'Knee operation package',
      'imageUrl': 'https://example.com/knee_replacement.jpg',
      'amount': 'BDT 8000',
    },
    // Add more operation package information here
  ];

  // Controller for search text field
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> filteredOperationPackages = [];

  @override
  void initState() {
    super.initState();
    filteredOperationPackages = availableOperationPackages;
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
      filteredOperationPackages = availableOperationPackages.where((package) {
        String packageName = package['name'].toLowerCase();
        return packageName.contains(query);
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
                  Text(
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
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: filteredOperationPackages.length,
                    itemBuilder: (BuildContext context, int index) {
                      final package = filteredOperationPackages[index];
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
                                    offset: Offset(0, 2), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 120,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        bottomLeft: Radius.circular(8),
                                      ),
                                      image: DecorationImage(
                                        image: NetworkImage(package['imageUrl']),
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
                                            package['name'],
                                            style: TextStyle(fontSize: 18, color: AppColors.primaryColor),
                                          ),
                                          const SizedBox(height: 5,),
                                          Text(
                                            package['description'],
                                            style: TextStyle(color: Colors.grey),
                                          ),
                                          const SizedBox(height: 12,),
                                          Text(
                                            'Amount: ${package['amount']}',
                                            style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueGrey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
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
