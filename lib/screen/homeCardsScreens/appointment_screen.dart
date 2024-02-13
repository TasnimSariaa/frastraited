import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';

class Appointment extends StatefulWidget {
  const Appointment({Key? key}) : super(key: key);

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  // Sample list of doctors for appointment booking
  final List<Map<String, dynamic>> doctorsForAppointment = [
    {
      'name': 'Dr. Alice Johnson',
      'specialty': 'Dermatologist',
      'profilePicUrl': 'https://example.com/doctor1.jpg',
    },
    {
      'name': 'Dr. Michael Smith',
      'specialty': 'Orthopedic Surgeon',
      'profilePicUrl': 'https://example.com/doctor2.jpg',
    },
    {
      'name': 'Dr. Emily Brown',
      'specialty': 'Pediatrician',
      'profilePicUrl': 'https://example.com/doctor3.jpg',
    },
    {
      'name': 'Dr. David Wilson',
      'specialty': 'Oncologist',
      'profilePicUrl': 'https://example.com/doctor4.jpg',
    },
    {
      'name': 'Dr. Sarah Lee',
      'specialty': 'Ophthalmologist',
      'profilePicUrl': 'https://example.com/doctor5.jpg',
    },
    {
      'name': 'Dr. William Clark',
      'specialty': 'Neurologist',
      'profilePicUrl': 'https://example.com/doctor6.jpg',
    },
    {
      'name': 'Dr. Olivia Martinez',
      'specialty': 'Gynecologist',
      'profilePicUrl': 'https://example.com/doctor7.jpg',
    },
    {
      'name': 'Dr. Daniel Taylor',
      'specialty': 'ENT Specialist',
      'profilePicUrl': 'https://example.com/doctor8.jpg',
    },
    // Add more doctors here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(height: 30),
                Stack(
                  children: [
                    Container(
                      height: 230,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    Positioned(
                      top: 45,
                      right: 44,
                      child: Container(
                        width: 175,
                        height: 163,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 60,
                      right: 40,
                      child: SvgPicture.asset(
                        'assets/images/appointment(11).svg',
                        width: 150,
                        height: 150,
                      ),

                    ),
                    Positioned(
                      left: 20,
                      top: 47,
                      child: Text(
                        "Book",
                        style: TextStyle(fontSize: 27, color: Colors.white),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      top: 70,
                      child: Text(
                        "Appointment",
                        style: TextStyle(fontSize: 27, color: Colors.white),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      bottom: 53,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Book Appointment'),
                              content: Text('Please choose a doctor from the list below.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Close'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Text(
                          "  Book Appointment  ",
                          style: TextStyle(fontSize: 18, color: AppColors.primaryColor),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Text(
                  ' Doctor List ',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                //SizedBox(width: double.infinity),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: doctorsForAppointment.length,
                    itemBuilder: (context, index) {
                      final doctor = doctorsForAppointment[index];
                      return Card(
                        borderOnForeground: true,
                        color: Colors.white, // Common color for all cards
                        elevation: 3,
                        child: Container(
                          height: 120, // Adjust the height of the container
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              Container(
                                width: 120,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: NetworkImage(doctor['profilePicUrl']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      doctor['name'],
                                      style: TextStyle(fontSize: 18, color: AppColors.primaryColor),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      doctor['specialty'],
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
