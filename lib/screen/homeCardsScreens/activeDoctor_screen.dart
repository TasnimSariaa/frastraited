import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/Precentation/ui/utility/search_field.dart'; // Import the SearchField widget
import 'package:frastraited/screen/service/database_service.dart';
import 'package:frastraited/screen/service/models/doctors.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';

class ActiveDoctor extends StatefulWidget {
  const ActiveDoctor({super.key});

  @override
  State<ActiveDoctor> createState() => _ActiveDoctorState();
}

class _ActiveDoctorState extends State<ActiveDoctor> {
  // Controller for search text field
  TextEditingController searchController = TextEditingController();

  List<DoctorModel> activeDoctors = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
    _getDoctorList();
  }

  void _getDoctorList() async {
    activeDoctors.clear();
    final result = await DatabaseService.instance.getDoctorInformation();
    activeDoctors.addAll(result);
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
    //   filteredDoctors = activeDoctors.where((doctor) {
    //     String doctorName = doctor['name'].toLowerCase();
    //     return doctorName.contains(query);
    //   }).toList();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyBackground(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : activeDoctors.isEmpty
                ? const Center(child: Text("List is Empty"))
                : SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: SingleChildScrollView(
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
                              height: 20,
                            ),
                            SearchField(
                              controller: searchController,
                              onTextChanged: (value) {
                                setState(() {}); // Trigger rebuild on text change
                              },
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Doctors On Duty',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: activeDoctors.length,
                              itemBuilder: (BuildContext context, int index) {
                                final doctor = activeDoctors[index];
                                return ListTile(
                                  leading: Stack(
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(doctor.profileImageUrl),
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
                                  trailing: doctor.isActive
                                      ? const Text(
                                          'On Duty',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        )
                                      : null,
                                  onTap: () {
                                    // Handle doctor selection
                                  },
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
