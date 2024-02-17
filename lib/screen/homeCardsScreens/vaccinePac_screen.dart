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
      'place': 'Annex building, 1st floor(Room 102)',
      'price': 'Free',
      'imageUrl':
      'https://images.unsplash.com/photo-1605289982774-9a6fef564df8?q=80&w=1964&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    },
    {
      'name': 'Influenza Vaccine',
      'place': 'Main hospital, 2nd floor(Room 201)',
      'price': 'BDT 500',
      'imageUrl': 'https://example.com/influenza_vaccine.jpg',
    },
    {
      'name': 'Hepatitis B Vaccine',
      'place': 'North Wing, 3rd floor(Room 301)',
      'price': 'BDT 1000',
      'imageUrl': 'https://example.com/hepatitis_b_vaccine.jpg',
    },
    {
      'name': 'HPV Vaccine',
      'place': 'South Wing, 4th floor(Room 401)',
      'price': 'BDT 750',
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
                                          'Available at: ${vaccine['place']}',
                                          style: TextStyle(color: Colors.black45),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Price: ${vaccine['price']}',
                                          style: TextStyle(color: Colors.blueGrey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          _showDeleteAlertDialog(context, index);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          _showEditBottomSheet(context, vaccine, index);
                                        },
                                      ),
                                    ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddBottomSheet(context);
        },
        child: Icon(Icons.add),
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }

  void _showDeleteAlertDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Vaccine?"),
          content: Text("Do you want to delete the vaccine from the list?"),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  availableVaccines.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: Text(
                "Delete",
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(AppColors.primaryColor),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void _showEditBottomSheet(BuildContext context, Map<String, dynamic> vaccine, int index) {
    TextEditingController nameController = TextEditingController(text: vaccine['name']);
    TextEditingController imageUrlController = TextEditingController(text: vaccine['imageUrl']);
    TextEditingController placeController = TextEditingController(text: vaccine['place']);
    TextEditingController priceController = TextEditingController(text: vaccine['price']);

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
                    controller: imageUrlController,
                    decoration: InputDecoration(labelText: 'Image URL'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: placeController,
                    decoration: InputDecoration(labelText: 'Place'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: priceController,
                    decoration: InputDecoration(labelText: 'Price'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        availableVaccines[index]['name'] = nameController.text;
                        availableVaccines[index]['imageUrl'] = imageUrlController.text;
                        availableVaccines[index]['place'] = placeController.text;
                        availableVaccines[index]['price'] = priceController.text;
                      });
                      Navigator.pop(context);
                    },
                    child: Text('Update', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAddBottomSheet(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController imageUrlController = TextEditingController();
    TextEditingController placeController = TextEditingController();
    TextEditingController priceController = TextEditingController();

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
                    controller: imageUrlController,
                    decoration: InputDecoration(labelText: 'Image URL'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: placeController,
                    decoration: InputDecoration(labelText: 'Place'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: priceController,
                    decoration: InputDecoration(labelText: 'Price'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        availableVaccines.add({
                          'name': nameController.text,
                          'imageUrl': imageUrlController.text,
                          'place': placeController.text,
                          'price': priceController.text,
                        });
                      });
                      Navigator.pop(context);
                    },
                    child: Text('Add', style: TextStyle(color: Colors.white)),
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