import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/Precentation/ui/utility/search_field.dart';
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
    searchController.addListener(_onSearchChanged);
  }

  void _getOperationList() async {
    operationList.clear();
    final result = await DatabaseService.instance.getOperationInformation();
    operationList.addAll(result);
    isLoading = false;
    setState(() {});
  }

  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    String query = searchController.text.toLowerCase();
    setState(() {
      operationList = operationList.where((operationPackage) {
        String packageName = operationPackage.name.toLowerCase();
        return packageName.contains(query);
      }).toList();
    });
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
                        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03,),
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
                            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                             Text(
                              'Available Operation Packages',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.06,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ),
                             SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                            SearchField(
                              controller: searchController,
                              onTextChanged: (value) {
                                setState(() {});
                              },
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: operationList.length,
                              itemBuilder: (BuildContext context, int index) {
                                final package = operationList[index];
                                return Column(
                                  children: [
                                    Container(
                                      height: MediaQuery.of(context).size.width * 0.4, // Adjusted height
                                      margin: const EdgeInsets.symmetric(vertical: 10), // Adjusted margin
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 4,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 120,
                                            height: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.only(
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
                                                  style: const TextStyle(fontSize: 18, color: AppColors.primaryColor),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  package.description,
                                                  style: const TextStyle(color: Colors.grey),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Amount: ${package.amount}',
                                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
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
        backgroundColor: AppColors.primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
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
                _showEditBottomSheet(context, package);
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
          title: const Text("Delete Operation Package?"),
          content: const Text("Do you want to delete the Package from the list?"),
          actions: [
            TextButton(
              onPressed: () async {
                operationList.remove(package);
                await DatabaseService.instance.deleteOperation(package);
                _getOperationList();
                setState(() {});
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(AppColors.primaryColor),
              ),
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: amountController,
                    decoration: const InputDecoration(labelText: 'Amount'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: imageUrlController,
                    decoration: const InputDecoration(labelText: 'Image URL'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final name = nameController.text;
                      final description = descriptionController.text;
                      final amount = amountController.text;
                      final imageUrl = imageUrlController.text;
                      final model = package.copyWith(name: name, amount: amount, operationImageUrl: imageUrl, description: description);

                      await DatabaseService.instance.updateOperationInformation(model);
                      _getOperationList();
                      Navigator.pop(context);
                    },
                    child: const Text('Update', style: TextStyle(color: Colors.white)),
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: amountController,
                    decoration: const InputDecoration(labelText: 'Amount'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: imageUrlController,
                    decoration: const InputDecoration(labelText: 'Image URL'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final name = nameController.text;
                      final description = descriptionController.text;
                      final amount = amountController.text;
                      final imageUrl = imageUrlController.text;

                      OperationModel model = OperationModel(id: '', name: name, description: description, amount: amount, operationImageUrl: imageUrl);

                      await DatabaseService.instance.setOperationInformation(model);
                      _getOperationList();
                      Navigator.pop(context);
                    },
                    child: const Text('Add', style: TextStyle(color: Colors.white)),
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
