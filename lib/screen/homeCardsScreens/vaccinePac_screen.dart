import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/Precentation/ui/utility/search_field.dart'; // Import the SearchField widget
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
      'place': 'Annex building, 1st floor (Room 102)',
      'price': 'Free',
      'imageUrl':
      'https://images.unsplash.com/photo-1605289982774-9a6fef564df8?q=80&w=1964&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    },
    {
      'name': 'Influenza Vaccine',
      'place': 'Main hospital, 2nd floor (Room 201)',
      'price': 'BDT 500',
      'imageUrl': 'https://example.com/influenza_vaccine.jpg',
    },
    {
      'name': 'Hepatitis B Vaccine',
      'place': 'North Wing, 3rd floor (Room 301)',
      'price': 'BDT 1000',
      'imageUrl': 'https://example.com/hepatitis_b_vaccine.jpg',
    },
    {
      'name': 'HPV Vaccine',
      'place': 'South Wing, 4th floor (Room 401)',
      'price': 'BDT 750',
      'imageUrl': 'https://example.com/hpv_vaccine.jpg',
    },
    // Add more vaccine information here
  ];

  // Controller for search text field
  TextEditingController searchController = TextEditingController();

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
                  const SizedBox(
                    height: 10,
                  ),
                  SearchField(
                    controller: searchController,
                    onTextChanged: (value) {
                      setState(() {}); // Trigger rebuild on text change
                    },
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Available Vaccines',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 35),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: availableVaccines.length,
                    itemBuilder: (BuildContext context, int index) {
                      final vaccine = availableVaccines[index];
                      return Column(
                        children: [
                          Container(
                            height: 140,
                            margin: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 120,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      bottomLeft: Radius.circular(12),
                                    ),
                                    image: DecorationImage(
                                      image: NetworkImage(vaccine['imageUrl']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        vaccine['name'],
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Available at: ${vaccine['place']}',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Price: ${vaccine['price']}',
                                        style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
