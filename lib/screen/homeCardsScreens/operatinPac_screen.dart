import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';

class OperationScreen extends StatefulWidget {
  const OperationScreen({Key? key}) : super(key: key);

  @override
  State<OperationScreen> createState() => _OperationScreenState();
}

class _OperationScreenState extends State<OperationScreen> {
  // Sample list of available operation packages
  final List<Map<String, dynamic>> availableOperationPackages = [
    {
      'name': 'Heart Surgery',
      'description': 'Heart operation package',
      'imageUrl': 'https://example.com/heart_surgery.jpg',
      'amount': 'BDT 10000',
    },
    {
      'name': 'Brain Surgery',
      'description': 'Brain operation package',
      'imageUrl': 'https://example.com/brain_surgery.jpg',
      'amount': 'BDT 15000',
    },
    {
      'name': 'Knee Replacement',
      'description': 'Knee operation package',
      'imageUrl': 'https://example.com/knee_replacement.jpg',
      'amount': 'BDT 8000',
    },
    // Add more operation package information here
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
                    height: 10,
                  ),
                  Text(
                    'Available Operation Packages',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 40),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: availableOperationPackages.length,
                    itemBuilder: (BuildContext context, int index) {
                      final package = availableOperationPackages[index];
                      return Column(
                        children: [
                          Card(
                            color: Colors.white,
                            elevation: 3,// Common color for all cards
                            borderOnForeground: true,
                            child: Container(
                              height: 120, // Adjust the height of the container
                              //padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  Container(
                                    width: 120,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: NetworkImage(package['imageUrl']),
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
                                          package['name'],
                                          style: TextStyle(fontSize: 18, color: AppColors.primaryColor),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          package['description'],
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Amount: ${package['amount']}',
                                          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueGrey),
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
