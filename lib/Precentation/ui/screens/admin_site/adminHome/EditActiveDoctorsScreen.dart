import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/Precentation/ui/utility/search_field.dart';
import 'package:frastraited/screen/service/database_service.dart';
import 'package:frastraited/screen/service/models/doctors.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';
import 'package:frastraited/screen/widgets/custom_image_view.dart';

class EditActiveDoctors extends StatefulWidget {
  const EditActiveDoctors({super.key});

  @override
  State<EditActiveDoctors> createState() => _EditActiveDoctorsState();
}

class _EditActiveDoctorsState extends State<EditActiveDoctors> {
  List<DoctorModel> activeDoctors = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getDoctorList();
  }

  void _getDoctorList() async {
    activeDoctors.clear();
    final result = await DatabaseService.instance.getDoctorInformation();
    activeDoctors.addAll(result);
    isLoading = false;
    setState(() {});
  }

  // Controller for search text field
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyBackground(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : activeDoctors.isEmpty
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
                            const SizedBox(height: 20),
                            SearchField(
                              controller: searchController,
                              onTextChanged: (value) {
                                setState(() {}); // Trigger rebuild on text change
                              },
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
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: activeDoctors.length,
                              itemBuilder: (BuildContext context, int index) {
                                final doctor = activeDoctors[index];
                                return ListTile(
                                  leading: Stack(
                                    children: [
                                      CustomImageView(
                                        height: 60,
                                        width: 60,
                                        path: doctor.profileImageUrl,
                                        borderRadius: BorderRadius.circular(15),
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
                                  title: Text(doctor.name),
                                  subtitle: Text(doctor.speciality),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Switch(
                                        value: doctor.isActive,
                                        onChanged: (newValue) async {
                                          List<DoctorModel> updatedDoctorsList = List.from(activeDoctors);
                                          final index = updatedDoctorsList.indexWhere((element) => element.id == doctor.id);

                                          if (index != -1) {
                                            updatedDoctorsList[index] = doctor.copyWith(isActive: newValue);
                                            await DatabaseService.instance.updateDoctorInformation(doctor.copyWith(isActive: newValue));
                                            setState(() => activeDoctors = updatedDoctorsList);
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
                    controller: specialityController,
                    decoration: const InputDecoration(labelText: 'Speciality'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: profilePicUrlController,
                    decoration: const InputDecoration(labelText: 'Profile Picture URL'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
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
                    controller: specialityController,
                    decoration: const InputDecoration(labelText: 'Speciality'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: profilePicUrlController,
                    decoration: const InputDecoration(labelText: 'Profile Picture URL'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final name = nameController.text;
                      final speciality = specialityController.text;
                      final profileImageUrl = profilePicUrlController.text;
                      DoctorModel model = DoctorModel(
                        id: "",
                        name: name,
                        speciality: speciality,
                        profileImageUrl: profileImageUrl,
                        isActive: false,
                      );
                      await DatabaseService.instance.setDoctorInformation(model);
                      _getDoctorList();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Add Doctor',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
