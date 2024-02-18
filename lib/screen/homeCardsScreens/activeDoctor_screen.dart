import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/Precentation/ui/utility/search_field.dart'; // Import the SearchField widget
import 'package:frastraited/screen/widgets/bodyBackground.dart';

class ActiveDoctor extends StatefulWidget {
  const ActiveDoctor({Key? key}) : super(key: key);

  @override
  State<ActiveDoctor> createState() => _ActiveDoctorState();
}

class _ActiveDoctorState extends State<ActiveDoctor> {
  // Sample list of active doctors
  final List<Map<String, dynamic>> activeDoctors = [
    {
      'name': 'Dr. Reza-Ul Karim',
      'speciality': 'Plastic Surgeon',
      'profilePicUrl': 'https://example.com/doctor3.jpg',
      'isActive': true,
    },
    {
      'name': 'Dr. Nabila Ferdous',
      'speciality': 'Gastroenterologist',
      'profilePicUrl': 'https://example.com/doctor4.jpg',
      'isActive': false,
    },
    {
      'name': 'Dr. John Doe',
      'speciality': 'Cardiologist',
      'profilePicUrl': 'https://example.com/doctor1.jpg',
      'isActive': true,
    },
    {
      'name': 'Dr. Jane Smith',
      'speciality': 'Neurologist',
      'profilePicUrl': 'https://example.com/doctor2.jpg',
      'isActive': false,
    },
    // Add more doctor information here
  ];

  // Controller for search text field
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> filteredDoctors = [];

  @override
  void initState() {
    super.initState();
    filteredDoctors = activeDoctors;
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Function to handle changes in the search text field
  void _onSearchChanged() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredDoctors = activeDoctors.where((doctor) {
        String doctorName = doctor['name'].toLowerCase();
        return doctorName.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyBackground(
        child: SafeArea(
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
                        icon: Icon(
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
                  Text(
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
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: filteredDoctors.length,
                    itemBuilder: (BuildContext context, int index) {
                      final doctor = filteredDoctors[index];
                      return ListTile(
                        leading: Stack(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(doctor['profilePicUrl']),
                            ),
                            if (doctor['isActive'])
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
                        title: Text(doctor['name']),
                        subtitle: Text(doctor['speciality']),
                        trailing: doctor['isActive']
                            ? Text(
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
