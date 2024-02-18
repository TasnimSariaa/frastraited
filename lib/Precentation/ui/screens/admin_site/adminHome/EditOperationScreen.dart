import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/Precentation/ui/utility/search_field.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';

class EditOperation extends StatefulWidget {
  const EditOperation({Key? key}) : super(key: key);

  @override
  State<EditOperation> createState() => _EditOperationState();
}

class _EditOperationState extends State<EditOperation> {
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

  void _onSearchChanged() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredOperationPackages = availableOperationPackages.where((operationPackage) {
        String packageName = operationPackage['name'].toLowerCase();
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
                        icon: Icon(Icons.arrow_back, color: AppColors.primaryColor,),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Available Operation Packages',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SearchField(
                    controller: searchController,
                    onTextChanged: (value) {
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 20),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: filteredOperationPackages.length,
                    itemBuilder: (BuildContext context, int index) {
                      final package = filteredOperationPackages[index];
                      return Column(
                        children: [
                          Container(
                            height: 120, // Adjusted height
                            margin: EdgeInsets.symmetric(vertical: 10), // Adjusted margin
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 120,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      bottomLeft: Radius.circular(12),
                                    ),
                                    image: DecorationImage(
                                      image: NetworkImage(package['imageUrl']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        package['name'],
                                        style: TextStyle(fontSize: 18, color: AppColors.primaryColor),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        package['description'],
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Amount: ${package['amount']}',
                                        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueGrey),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        _showDeleteAlertDialog(context, index);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        _showEditBottomSheet(context, package, index);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddBottomSheet(context);
        },
        child: Icon(Icons.add,color: Colors.white,),
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }

  void _showDeleteAlertDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Operation Package?"),
          content: Text("Do you want to delete the Package from the list?"),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  availableOperationPackages.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: Text(
                "Delete",
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(AppColors.primaryColor),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void _showEditBottomSheet(BuildContext context, Map<String, dynamic> package, int index) {
    TextEditingController nameController = TextEditingController(text: package['name']);
    TextEditingController descriptionController = TextEditingController(text: package['description']);
    TextEditingController amountController = TextEditingController(text: package['amount']);
    TextEditingController imageUrlController = TextEditingController(text: package['imageUrl']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: amountController,
                    decoration: InputDecoration(labelText: 'Amount'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: imageUrlController,
                    decoration: InputDecoration(labelText: 'Image URL'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        availableOperationPackages[index]['name'] = nameController.text;
                        availableOperationPackages[index]['description'] = descriptionController.text;
                        availableOperationPackages[index]['amount'] = amountController.text;
                        availableOperationPackages[index]['imageUrl'] = imageUrlController.text;
                      });
                      Navigator.pop(context);
                    },
                    child: Text('Update', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAddBottomSheet(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    TextEditingController imageUrlController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: amountController,
                    decoration: InputDecoration(labelText: 'Amount'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: imageUrlController,
                    decoration: InputDecoration(labelText: 'Image URL'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        availableOperationPackages.add({
                          'name': nameController.text,
                          'description': descriptionController.text,
                          'amount': amountController.text,
                          'imageUrl': imageUrlController.text,
                        });
                      });
                      Navigator.pop(context);
                    },
                    child: Text('Add', style: TextStyle(color: Colors.white)),
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
