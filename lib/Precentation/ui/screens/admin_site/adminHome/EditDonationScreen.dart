import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/Precentation/ui/widgets/empty_container_view.dart';
import 'package:frastraited/screen/service/database_service.dart';
import 'package:frastraited/screen/service/models/donation_model.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';
import 'package:image_picker/image_picker.dart';

class EditDonation extends StatefulWidget {
  const EditDonation({super.key});

  @override
  State<EditDonation> createState() => _EditDonationState();
}

class _EditDonationState extends State<EditDonation> {
  List<DonationModel> donationList = [];
  List<DonationModel> tempDonationList = [];

  bool isLoading = true;

  // Controller for search text field
  TextEditingController searchController = TextEditingController();

  late File _image;
  final ImagePicker _picker = ImagePicker();

  String _downloadUrl = '';

  get imageUrlController => null;

  @override
  void initState() {
    super.initState();
    _getDonationList();
    searchController.addListener(_onSearchChanged);
  }

  void _getDonationList() async {
    final result = await DatabaseService.instance.getDonationList();
    donationList.clear();
    donationList.addAll(result);
    tempDonationList = donationList;
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
      tempDonationList = donationList;
    } else {
      tempDonationList = donationList.where((value) {
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
            : donationList.isEmpty
                ? const Center(child: EmptyContainerView())
                : SafeArea(
                    child: SingleChildScrollView(
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
                          Text(
                            'Admitted Needy Patients',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: searchController,
                            decoration: const InputDecoration(
                              labelText: 'Search',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 30),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: tempDonationList.length,
                            itemBuilder: (BuildContext context, int index) {
                              final patient = tempDonationList[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                padding: const EdgeInsets.all(10),
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      title: Text(patient.name),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Age: ${patient.age}'),
                                          Text('Ward Number: ${patient.wardNumber}'),
                                          Text('Bed Number: ${patient.bedNumber}'),
                                          Text('Disease: ${patient.disease}'),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () {
                                            _showEditBottomSheet(context, patient);
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () {
                                            _showDeleteAlertDialog(context, patient);
                                          },
                                        ),
                                      ],
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

  void _showDeleteAlertDialog(BuildContext context, DonationModel model) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Patient?"),
          content: const Text("Do you want to delete the patient from the list?"),
          actions: [
            TextButton(
              onPressed: () async {
                donationList.remove(model);
                tempDonationList.remove(model);
                await DatabaseService.instance.deleteDonations(model);
                _getDonationList();
                setState(() {});
                Navigator.pop(context);
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

  void _showEditBottomSheet(BuildContext context, DonationModel patient) {
    TextEditingController nameController = TextEditingController(text: patient.name);
    TextEditingController ageController = TextEditingController(text: patient.age);
    TextEditingController wardNumberController = TextEditingController(text: patient.wardNumber);
    TextEditingController bedNumberController = TextEditingController(text: patient.bedNumber);
    TextEditingController diseaseController = TextEditingController(text: patient.disease);

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
                  "Patients Information",
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
                  controller: ageController,
                  decoration: const InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Field is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: wardNumberController,
                  decoration: const InputDecoration(labelText: 'Ward Number'),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Field is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: bedNumberController,
                  decoration: const InputDecoration(labelText: 'Bed Number'),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Field is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: diseaseController,
                  decoration: const InputDecoration(labelText: 'Disease'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: imageUrlController,
                  readOnly: true,
                  onTap: () => _getImage(_picker, imageUrlController),
                  decoration: InputDecoration(
                    labelText: 'Image URL',
                    suffixIcon: IconButton(
                      onPressed: () async {
                        _getImage(_picker, imageUrlController);
                      },
                      icon: const Icon(Icons.image_search),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    final isValid = formKey.currentState?.validate() ?? false;
                    if (!isValid) return;

                    final name = nameController.text;
                    final age = ageController.text;
                    final wardNumber = wardNumberController.text;
                    final bedNumber = bedNumberController.text;
                    final disease = diseaseController.text;
                    final imageUrl = imageUrlController.text;
                    await DatabaseService.instance.updateDonations(
                      patient.copyWith(
                        name: name,
                        age: age,
                        wardNumber: wardNumber,
                        bedNumber: bedNumber,
                        disease: disease,
                        imageUrl: imageUrl,
                      ),
                    );
                    _getDonationList();
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
    TextEditingController ageController = TextEditingController();
    TextEditingController wardNumberController = TextEditingController();
    TextEditingController bedNumberController = TextEditingController();
    TextEditingController diseaseController = TextEditingController();
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
                  "Patients Information",
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
                  controller: ageController,
                  decoration: const InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Field is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: wardNumberController,
                  decoration: const InputDecoration(labelText: 'Ward Number'),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Field is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: bedNumberController,
                  decoration: const InputDecoration(labelText: 'Bed Number'),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Field is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: diseaseController,
                  decoration: const InputDecoration(labelText: 'Disease'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: imageUrlController,
                  readOnly: true,
                  onTap: () => _getImage(_picker, imageUrlController),
                  decoration: InputDecoration(
                    labelText: 'Image URL',
                    suffixIcon: IconButton(
                      onPressed: () => _getImage(_picker, imageUrlController),
                      icon: const Icon(Icons.image_search),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    final isValid = formKey.currentState?.validate() ?? false;
                    if (!isValid) return;

                    final name = nameController.text;
                    final age = ageController.text;
                    final wardNumber = wardNumberController.text;
                    final bedNumber = bedNumberController.text;
                    final disease = diseaseController.text;
                    final imageUrl = imageUrlController.text;
                    DonationModel donation = DonationModel(
                      id: "",
                      name: name,
                      age: age,
                      wardNumber: wardNumber,
                      bedNumber: bedNumber,
                      disease: disease,
                      imageUrl: imageUrl,
                    );
                    await DatabaseService.instance.addDonations(donation);
                    _getDonationList();
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
