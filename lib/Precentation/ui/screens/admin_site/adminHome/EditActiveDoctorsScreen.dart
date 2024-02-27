import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/Precentation/ui/utility/search_field.dart';
import 'package:frastraited/Precentation/ui/widgets/empty_container_view.dart';
import 'package:frastraited/screen/service/database_service.dart';
import 'package:frastraited/screen/service/models/doctors.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';
import 'package:frastraited/screen/widgets/custom_image_view.dart';
import 'package:image_picker/image_picker.dart';

class EditActiveDoctors extends StatefulWidget {
  const EditActiveDoctors({super.key});

  @override
  State<EditActiveDoctors> createState() => _EditActiveDoctorsState();
}

class _EditActiveDoctorsState extends State<EditActiveDoctors> {
  List<DoctorModel> activeDoctors = [];
  List<DoctorModel> tempDoctorList = [];

  bool isLoading = true;

  // Controller for search text field
  TextEditingController searchController = TextEditingController();

  late File _image;
  final ImagePicker _picker = ImagePicker();

  String _downloadUrl = '';

  @override
  void initState() {
    super.initState();
    _getDoctorList();
    searchController.addListener(_onSearchChanged);
  }

  void _getDoctorList() async {
    final result = await DatabaseService.instance.getDoctorInformation();
    activeDoctors.clear();
    activeDoctors.addAll(result);
    tempDoctorList = activeDoctors;
    isLoading = false;
    setState(() {});
  }

  void _onSearchChanged() {
    String query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      tempDoctorList = activeDoctors;
    } else {
      tempDoctorList = activeDoctors.where((patient) {
        String patientName = patient.name.toLowerCase();
        return patientName.contains(query);
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
            : activeDoctors.isEmpty
                ? const Center(child: EmptyContainerView())
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
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
                          SearchField(
                            controller: searchController,
                            onTextChanged: (value) {},
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Active Doctors',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ListView.separated(
                            shrinkWrap: true,
                            separatorBuilder: (_, __) => const SizedBox(height: 20),
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: tempDoctorList.length,
                            itemBuilder: (BuildContext context, int index) {
                              final doctor = tempDoctorList[index];
                              return Row(
                                children: [
                                  Stack(
                                    children: [
                                      CustomImageView(
                                        height: 60,
                                        width: 60,
                                        path: doctor.profileImageUrl,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      if (doctor.isActive)
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          child: Container(
                                            width: 15,
                                            height: 15,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.green,
                                              border: Border.all(color: Colors.white, width: 2),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(doctor.name),
                                        const SizedBox(height: 4),
                                        Text(doctor.speciality),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Switch(
                                    value: doctor.isActive,
                                    onChanged: (newValue) async {
                                      List<DoctorModel> updatedDoctorsList = List.from(tempDoctorList);
                                      final index = updatedDoctorsList.indexWhere((element) => element.id == doctor.id);

                                      if (index != -1) {
                                        updatedDoctorsList[index] = doctor.copyWith(isActive: newValue);
                                        await DatabaseService.instance.updateDoctorInformation(doctor.copyWith(isActive: newValue));
                                        setState(() => tempDoctorList = updatedDoctorsList);
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.more_vert),
                                    onPressed: () {
                                      _showEditDialog(context, doctor);
                                    },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDoctorBottomSheet(context);
        },
        backgroundColor: AppColors.primaryColor, // Set the background color
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, DoctorModel doctor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modify Doctor'),
          content: const Text('Do you want to modify the Doctor list?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showEditBottomSheet(context, doctor);
              },
              child: const Text('Update'),
            ),
            TextButton(
              onPressed: () async {
                activeDoctors.remove(doctor);
                await DatabaseService.instance.deleteDoctor(doctor);
                _getDoctorList();
                setState(() {});
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showEditBottomSheet(BuildContext context, DoctorModel doctor) {
    TextEditingController nameController = TextEditingController(text: doctor.name);
    TextEditingController specialityController = TextEditingController(text: doctor.speciality);
    TextEditingController profilePicUrlController = TextEditingController(text: doctor.profileImageUrl);
    TextEditingController visitingFeeController = TextEditingController(text: doctor.visitingFee);

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
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
                    "Doctor Information",
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
                    controller: specialityController,
                    decoration: const InputDecoration(labelText: 'Speciality'),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Field is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: visitingFeeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Visiting Fee'),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Field is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: profilePicUrlController,
                    readOnly: true,
                    onTap: () => _getImage(_picker, profilePicUrlController),
                    decoration: InputDecoration(
                      labelText: 'Profile Picture URL',
                      suffixIcon: IconButton(
                        onPressed: () async {
                          _getImage(_picker, profilePicUrlController);
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
                      final speciality = specialityController.text;
                      final profilePicUrl = profilePicUrlController.text;
                      final model = doctor.copyWith(name: name, speciality: speciality, profileImageUrl: profilePicUrl);
                      await DatabaseService.instance.updateDoctorInformation(model);
                      _getDoctorList();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAddDoctorBottomSheet(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController specialityController = TextEditingController();
    TextEditingController profilePicUrlController = TextEditingController();
    TextEditingController visitingFeeController = TextEditingController();

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
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
                    "Doctor Information",
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
                    controller: specialityController,
                    decoration: const InputDecoration(labelText: 'Speciality'),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Field is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: visitingFeeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Visiting Fee'),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Field is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: profilePicUrlController,
                    readOnly: true,
                    onTap: () => _getImage(_picker, profilePicUrlController),
                    decoration: InputDecoration(
                      labelText: 'Profile Picture URL',
                      suffixIcon: IconButton(
                        onPressed: () async {
                          _getImage(_picker, profilePicUrlController);
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
                      final speciality = specialityController.text;
                      final profileImageUrl = profilePicUrlController.text;
                      final visitingFee = visitingFeeController.text;
                      DoctorModel model = DoctorModel(
                        id: "",
                        name: name,
                        speciality: speciality,
                        visitingFee: visitingFee,
                        profileImageUrl: profileImageUrl,
                        isActive: false,
                      );
                      await DatabaseService.instance.setDoctorInformation(model);
                      _getDoctorList();
                      Navigator.pop(context);
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Add Doctor',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
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

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
