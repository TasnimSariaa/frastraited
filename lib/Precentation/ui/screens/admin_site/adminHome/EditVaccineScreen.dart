import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/Precentation/ui/utility/search_field.dart';
import 'package:frastraited/Precentation/ui/widgets/empty_container_view.dart';
import 'package:frastraited/screen/service/database_service.dart';
import 'package:frastraited/screen/service/models/vaccines.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';
import 'package:image_picker/image_picker.dart';

class EditVaccine extends StatefulWidget {
  const EditVaccine({super.key});

  @override
  State<EditVaccine> createState() => _EditVaccineState();
}

class _EditVaccineState extends State<EditVaccine> {
  List<VaccineModel> vaccineList = [];
  List<VaccineModel> tempVaccineList = [];

  bool isLoading = true;

  // Controller for search text field
  TextEditingController searchController = TextEditingController();

  late File _image;
  final ImagePicker _picker = ImagePicker();

  String _downloadUrl = '';

  @override
  void initState() {
    super.initState();
    _getVaccineList();
    searchController.addListener(_onSearchChanged);
  }

  void _getVaccineList() async {
    final result = await DatabaseService.instance.getVaccineInformation();
    vaccineList.clear();
    vaccineList.addAll(result);
    tempVaccineList = vaccineList;
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
      tempVaccineList = vaccineList;
    } else {
      tempVaccineList = vaccineList.where((value) {
        String name = value.name.toLowerCase();
        return name.contains(query);
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
            : vaccineList.isEmpty
                ? const Center(child: EmptyContainerView())
                : SingleChildScrollView(
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
                          const Text(
                            'Available Vaccines',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 30),
                          SearchField(
                            controller: searchController,
                            onTextChanged: (value) {},
                          ),
                          const SizedBox(height: 20),
                          ListView.separated(
                            shrinkWrap: true,
                            separatorBuilder: (_, __) => const SizedBox(height: 20),
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: tempVaccineList.length,
                            itemBuilder: (BuildContext context, int index) {
                              final vaccine = tempVaccineList[index];

                              return Container(
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
                                      height: 120,
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      margin: const EdgeInsetsDirectional.only(end: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          bottomLeft: Radius.circular(12),
                                        ),
                                        image: DecorationImage(
                                          image: NetworkImage(vaccine.vaccineImageUrl),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            vaccine.name,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primaryColor,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            'Available at: ${vaccine.place}',
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.black54,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            'Price: ${vaccine.price}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.blueGrey,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.more_vert),
                                      onPressed: () {
                                        _showEditDialog(context, vaccine);
                                      },
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

  void _showEditDialog(BuildContext context, VaccineModel vaccine) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modify Vaccine'),
          content: const Text('Do you want to modify Vaccine list?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showEditBottomSheet(context, vaccine);
              },
              child: const Text('Update'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                _showDeleteAlertDialog(context, vaccine);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAlertDialog(BuildContext context, VaccineModel vaccine) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Vaccine?"),
          content: const Text("Do you want to delete the vaccine from the list?"),
          actions: [
            TextButton(
              onPressed: () async {
                vaccineList.remove(vaccine);
                tempVaccineList.remove(vaccine);
                await DatabaseService.instance.deleteVaccine(vaccine);
                _getVaccineList();
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

  void _showEditBottomSheet(BuildContext context, VaccineModel vaccine) {
    TextEditingController nameController = TextEditingController(text: vaccine.name);
    TextEditingController imageUrlController = TextEditingController(text: vaccine.vaccineImageUrl);
    TextEditingController placeController = TextEditingController(text: vaccine.place);
    TextEditingController priceController = TextEditingController(text: vaccine.price);

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
                  "Vaccines Information",
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
                  controller: placeController,
                  decoration: const InputDecoration(labelText: 'Place'),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Field is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Price'),
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
                    final imageUrl = imageUrlController.text;
                    final price = priceController.text;
                    final place = placeController.text;
                    final model = vaccine.copyWith(name: name, vaccineImageUrl: imageUrl, place: place, price: price);
                    await DatabaseService.instance.updateVaccineInformation(model);
                    _getVaccineList();
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
    TextEditingController imageUrlController = TextEditingController();
    TextEditingController placeController = TextEditingController();
    TextEditingController priceController = TextEditingController();

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
                  "Vaccines Information",
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
                  controller: placeController,
                  decoration: const InputDecoration(labelText: 'Place'),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Field is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Price'),
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
                    final imageUrl = imageUrlController.text;
                    final price = priceController.text;
                    final place = placeController.text;

                    VaccineModel model = VaccineModel(id: '', name: name, price: price, place: place, vaccineImageUrl: imageUrl);
                    await DatabaseService.instance.setVaccineInformation(model);
                    _getVaccineList();

                    Navigator.pop(context);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('Add', style: TextStyle(color: Colors.white))],
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
