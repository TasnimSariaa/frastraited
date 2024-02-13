import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';

class VaccineScreen extends StatefulWidget {
  const VaccineScreen({Key? key}) : super(key: key);

  @override
  State<VaccineScreen> createState() => _VaccineScreenState();
}

class _VaccineScreenState extends State<VaccineScreen> {
  // Sample list of available vaccines
  final List<Map<String, dynamic>> availableVaccines = [
    {
      'name': 'COVID-19 Vaccine',
      'description': 'Protects against COVID-19 virus',
      'imageUrl': 'https://images.unsplash.com/photo-1605289982774-9a6fef564df8?q=80&w=1964&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    },
    {
      'name': 'Influenza Vaccine',
      'description': 'Protects against influenza virus',
      'imageUrl': 'https://example.com/influenza_vaccine.jpg',
    },
    {
      'name': 'Hepatitis B Vaccine',
      'description': 'Protects against hepatitis B virus',
      'imageUrl': 'https://example.com/hepatitis_b_vaccine.jpg',
    },
    {
      'name': 'HPV Vaccine',
      'description': 'Protects against human papillomavirus',
      'imageUrl': 'https://example.com/hpv_vaccine.jpg',
    },
    // Add more vaccine information here
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
                        icon: Icon(Icons.arrow_back,
                          color: AppColors.primaryColor,),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    'Available Vaccines',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: availableVaccines.length,
                    itemBuilder: (BuildContext context, int index) {
                      final vaccine = availableVaccines[index];
                      return Column(
                        children: [
                          Card(
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
                                        image: NetworkImage(vaccine['imageUrl']),
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
                                          vaccine['name'],
                                          style: TextStyle(fontSize: 18, color: AppColors.primaryColor),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          vaccine['description'],
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
      ),
    );
  }
}