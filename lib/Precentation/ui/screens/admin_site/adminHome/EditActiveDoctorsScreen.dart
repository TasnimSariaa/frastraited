import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';

class EditActiveDoctors extends StatefulWidget {
  const EditActiveDoctors({Key? key}) : super(key: key);

  @override
  State<EditActiveDoctors> createState() => _EditActiveDoctorsState();
}

class _EditActiveDoctorsState extends State<EditActiveDoctors> {
  // Sample list of active doctors (to be replaced with database functionality)
  List<Map<String, dynamic>> activeDoctors = [
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
    // Add more doctor information here
  ];

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
                  const SizedBox(height: 20),
                  Text(
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
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: activeDoctors.length,
                    itemBuilder: (BuildContext context, int index) {
                      final doctor = activeDoctors[index];
                      return ListTile(
                        leading: Stack(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  NetworkImage(doctor['profilePicUrl']),
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
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        title: Text(doctor['name']),
                        subtitle: Text(doctor['speciality']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Toggle button to update active status
                            Theme(
                              data: ThemeData(
                                toggleableActiveColor: AppColors.primaryColor,
                              ),
                              child: Switch(
                                value: doctor['isActive'],
                                onChanged: (newValue) {
                                  setState(() {
                                    doctor['isActive'] = newValue;
                                  });
                                },
                              ),
                            ),
                            // Dialog for update/delete options
                            IconButton(
                              icon: Icon(Icons.more_vert),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Modify Doctor'),
                                    content: Text(
                                        'Do you want to modify this doctor?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          // Handle update doctor
                                          Navigator.pop(context);
                                        },
                                        child: Text('Update'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // Handle delete doctor
                                          setState(() {
                                            activeDoctors.removeAt(index);
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );
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
          // Handle adding a new doctor
          // You can open a new screen or a dialog to input doctor details
        },
        backgroundColor: AppColors.primaryColor, // Set the background color
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
