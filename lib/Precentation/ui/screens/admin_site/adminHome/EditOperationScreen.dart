import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/Precentation/ui/utility/search_field.dart';
import 'package:frastraited/Precentation/ui/widgets/empty_container_view.dart';
import 'package:frastraited/screen/service/database_service.dart';
import 'package:frastraited/screen/service/models/operationPackages.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';
import 'package:image_picker/image_picker.dart';

class EditOperation extends StatefulWidget {
  const EditOperation({Key? key}) : super(key: key);

  @override
  State<EditOperation> createState() => _EditOperationState();
}

class _EditOperationState extends State<EditOperation> {
  List<OperationModel> operationList = [];
  List<OperationModel> tempOperationList = [];
  bool isLoading = true;

  // Controller for search text field
  TextEditingController searchController = TextEditingController();

  late File _image;
  final ImagePicker _picker = ImagePicker();

  String _downloadUrl = '';

  @override
  void initState() {
    super.initState();
    _getOperationList();
    searchController.addListener(_onSearchChanged);
  }

  void _getOperationList() async {
    final result = await DatabaseService.instance.getOperationInformation();
    operationList.clear();
    operationList.addAll(result);
    tempOperationList = operationList;
    isLoading = false;
    setState(() {});
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    String query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      tempOperationList = operationList;
    } else {
      tempOperationList = operationList.where((package) {
        String packageName = package.name.toLowerCase();
        return packageName.contains(query);
      }).toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyBackground(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : operationList.isEmpty
                ? const Center(child: EmptyContainerView())
                : SingleChildScrollView(
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
                        const SizedBox(height: 10),
                        const Text(
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
                          onTextChanged: (value) {},
                        ),
                        const SizedBox(height: 20),
                        ListView.separated(
                          shrinkWrap: true,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: tempOperationList.length,
                          itemBuilder: (BuildContext context, int index) {
                            final package = tempOperationList[index];
                            return Column(
                              children: [
                                Container(
                                  height: 120, // Adjusted height
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
                                              maxLines: 2,
                                              style: const TextStyle(fontSize: 18, color: AppColors.primaryColor),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              package.description,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
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
                tempOperationList.remove(package);
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

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Operation Package Information",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Field is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Field is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Amount'),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Field is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: imageUrlController,
                  decoration: InputDecoration(
                    labelText: 'Image URL',
                    suffixIcon: IconButton(
                      onPressed: () async {
                        _getImage(_picker, imageUrlController);
                      },
                      icon: const Icon(Icons.image_search),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Field is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    final isValid = formKey.currentState?.validate() ?? false;
                    if (!isValid) return;

                    final name = nameController.text;
                    final description = descriptionController.text;
                    final amount = amountController.text;
                    final imageUrl = imageUrlController.text;
                    final model = package.copyWith(name: name, amount: amount, operationImageUrl: imageUrl, description: description);

                    await DatabaseService.instance.updateOperationInformation(model);
                    _getOperationList();
                    Navigator.pop(context);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Update', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
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

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Operation Package Information",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Field is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Field is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Amount'),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Field is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: imageUrlController,
                  decoration: InputDecoration(
                    labelText: 'Image URL',
                    suffixIcon: IconButton(
                      onPressed: () async {
                        _getImage(_picker, imageUrlController);
                      },
                      icon: const Icon(Icons.image_search),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Field is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    final isValid = formKey.currentState?.validate() ?? false;
                    if (!isValid) return;

                    final name = nameController.text;
                    final description = descriptionController.text;
                    final amount = amountController.text;
                    final imageUrl = imageUrlController.text;

                    OperationModel model = OperationModel(id: '', name: name, description: description, amount: amount, operationImageUrl: imageUrl);

                    await DatabaseService.instance.setOperationInformation(model);
                    _getOperationList();
                    Navigator.pop(context);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Add', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _getImage(ImagePicker picker, TextEditingController profilePicUrlController) async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _image = File(image.path);
        _uploadImage(File(image.path), profilePicUrlController);
      }
    });
  }

  void _uploadImage(File file, TextEditingController profilePicUrlController) async {
    final user = FirebaseAuth.instance.currentUser;
    final storage = FirebaseStorage.instance;
    final Reference storageRef = storage.ref().child('images/${user?.uid}/${DateTime.now().toString()}');
    final UploadTask uploadTask = storageRef.putFile(file);
    await uploadTask.whenComplete(() async {
      _downloadUrl = await storageRef.getDownloadURL();
      profilePicUrlController.text = _downloadUrl;
    });
    setState(() {});
  }
}
