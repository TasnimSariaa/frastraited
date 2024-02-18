import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/screen/service/database_service.dart';
import 'package:frastraited/screen/service/models/operationPackages.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';

class EditOperation extends StatefulWidget {
  const EditOperation({Key? key}) : super(key: key);

  @override
  State<EditOperation> createState() => _EditOperationState();
}

class _EditOperationState extends State<EditOperation> {

  List<OperationModel> operationList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getOperationList();
  }

  void _getOperationList() async {
    operationList.clear();
    final result = await DatabaseService.instance.getOperationInformation();
    operationList.addAll(result);
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

                  const SizedBox(height: 40),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: operationList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final package =operationList[index];
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
                                      image: NetworkImage(package.operationImageUrl),
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
                                        package.name,
                                        style: TextStyle(fontSize: 18, color: AppColors.primaryColor),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        package.description,
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Amount: ${package.amount}',
                                        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueGrey),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.more_vert),
                                  onPressed: () {
                                    _showEditDialog(context, package);
                                  },
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
        child: Icon(Icons.add),
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }

  void _showEditDialog(BuildContext context, OperationModel package) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modify Operation Packages'),
          content: const Text('Do you want to modify Operation Package?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showEditBottomSheet(context,package);
              },
              child: const Text('Update'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                _showDeleteAlertDialog(context, package);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAlertDialog(BuildContext context, OperationModel package) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Operation Package?"),
          content: Text("Do you want to delete the Package from the list?"),
          actions: [
            TextButton(
              onPressed: () async {
                operationList.remove(package);
                await DatabaseService.instance.deleteOperation(package);
                _getOperationList();
                setState(() {});
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

  void _showEditBottomSheet(BuildContext context, OperationModel package) {
    TextEditingController nameController = TextEditingController(text: package.name);
    TextEditingController descriptionController = TextEditingController(text: package.description);
    TextEditingController amountController = TextEditingController(text: package.amount);
    TextEditingController imageUrlController = TextEditingController(text: package.operationImageUrl);

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
                    onPressed: () async {
                      final name = nameController.text;
                      final description = descriptionController.text;
                      final amount= amountController.text;
                      final imageUrl= imageUrlController.text;
                      final model = package.copyWith(
                        name: name,
                        amount: amount,
                        operationImageUrl: imageUrl,
                        description: description
                      );

                      await DatabaseService.instance.updateOperationInformation(model);
                      _getOperationList();
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
                    onPressed: () async {
                      final name = nameController.text;
                      final description = descriptionController.text;
                      final amount= amountController.text;
                      final imageUrl= imageUrlController.text;

                      OperationModel model = OperationModel(
                          id: '',
                          name: name,
                          description: description,
                          amount: amount,
                          operationImageUrl: imageUrl
                      );

                      await DatabaseService.instance.setOperationInformation(model);
                      _getOperationList();
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
