import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/Precentation/ui/utility/search_field.dart'; // Import the SearchField widget
import 'package:frastraited/Precentation/ui/widgets/empty_container_view.dart';
import 'package:frastraited/screen/service/database_service.dart';
import 'package:frastraited/screen/service/models/doctors.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';
import 'package:frastraited/screen/widgets/custom_image_view.dart';

class ActiveDoctor extends StatefulWidget {
  const ActiveDoctor({super.key});

  @override
  State<ActiveDoctor> createState() => _ActiveDoctorState();
}

class _ActiveDoctorState extends State<ActiveDoctor> {
  List<DoctorModel> activeDoctors = [];
  List<DoctorModel> tempDoctorList = [];

  bool isLoading = true;

  // Controller for search text field
  TextEditingController searchController = TextEditingController();

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

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Function to handle changes in the search text field
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
                : SafeArea(
                    child: SingleChildScrollView(
                      padding: const EdgeInsetsDirectional.only(start: 20, end: 20, bottom: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 24),
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
                            'Doctors On Duty',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            separatorBuilder: (_, __) => const SizedBox(height: 20),
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
                                  if (doctor.isActive) ...[
                                    const Text(
                                      'On Duty',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
