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
                               Switch(
                                value: doctor['isActive'],
                                onChanged: (newValue) {
                                  setState(() {
                                    doctor['isActive'] = newValue;
                                  });
                                },
                              ),

                            // Dialog for update/delete options
                            IconButton(
                              icon: Icon(Icons.more_vert),
                              onPressed: () {
                                _showEditDialog(context, index);
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
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, int index) {
    Map<String, dynamic> doctor = activeDoctors[index];

    TextEditingController nameController = TextEditingController(text: doctor['name']);
    TextEditingController specialityController = TextEditingController(text: doctor['speciality']);
    TextEditingController profilePicUrlController = TextEditingController(text: doctor['profilePicUrl']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modify Doctor'),
          content: Text('Do you want to modify the Doctor list?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showEditBottomSheet(context, doctor, index);
              },
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  activeDoctors.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showEditBottomSheet(BuildContext context, Map<String, dynamic> doctor, int index) {
    TextEditingController nameController = TextEditingController(text: doctor['name']);
    TextEditingController specialityController = TextEditingController(text: doctor['speciality']);
    TextEditingController profilePicUrlController = TextEditingController(text: doctor['profilePicUrl']);

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
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: specialityController,
                    decoration: InputDecoration(labelText: 'Speciality'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: profilePicUrlController,
                    decoration: InputDecoration(labelText: 'Profile Picture URL'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        // Update doctor information
                        activeDoctors[index]['name'] = nameController.text;
                        activeDoctors[index]['speciality'] = specialityController.text;
                        activeDoctors[index]['profilePicUrl'] = profilePicUrlController.text;
                      });
                      Navigator.pop(context);
                    },
                    child: Text(
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
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: specialityController,
                    decoration: InputDecoration(labelText: 'Speciality'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: profilePicUrlController,
                    decoration: InputDecoration(labelText: 'Profile Picture URL'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        // Add new doctor to the list
                        activeDoctors.add({
                          'name': nameController.text,
                          'speciality': specialityController.text,
                          'profilePicUrl': profilePicUrlController.text,
                          'isActive': false, // Default to inactive
                        });
                      });
                      Navigator.pop(context);
                    },
                    child: Text(
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
}
