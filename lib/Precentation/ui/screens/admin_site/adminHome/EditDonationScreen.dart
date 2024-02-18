import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';

class EditDonation extends StatefulWidget {
  const EditDonation({Key? key}) : super(key: key);

  @override
  State<EditDonation> createState() => _EditDonationState();
}

class _EditDonationState extends State<EditDonation> {
  final List<Map<String, dynamic>> admittedNeedyPatients = [
    {
      'name': 'John Doe',
      'age': 45,
      'wardNumber': 'Ward 101',
      'bedNumber': 'Bed 12',
      'disease': 'Cancer',
    },
    {
      'name': 'Jane Smith',
      'age': 30,
      'wardNumber': 'Ward 201',
      'bedNumber': 'Bed 25',
      'disease': 'Heart Disease',
    },
    // Add more admitted needy patients here
  ];

  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> filteredPatients = [];

  @override
  void initState() {
    super.initState();
    filteredPatients = admittedNeedyPatients;
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredPatients = admittedNeedyPatients.where((patient) {
        String patientName = patient['name'].toLowerCase();
        return patientName.contains(query);
      }).toList();
    });
  }

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
                  const SizedBox(height: 10),
                  Text(
                    'Admitted Needy Patients',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 30),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: filteredPatients.length,
                    itemBuilder: (BuildContext context, int index) {
                      final patient = filteredPatients[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 20),
                        padding: EdgeInsets.all(10),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(patient['name']),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Age: ${patient['age']}'),
                                  Text('Ward Number: ${patient['wardNumber']}'),
                                  Text('Bed Number: ${patient['bedNumber']}'),
                                  Text('Disease: ${patient['disease']}'),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // Handle the action for uploading patient's picture
                                  },
                                  icon: Icon(Icons.file_upload),
                                  label: Text('Upload Picture   '),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    onPrimary: Colors.white,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        _showEditBottomSheet(context, patient, index);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        _showDeleteAlertDialog(context, index);
                                      },
                                    ),
                                  ],
                                ),
                              ],
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
          _showAddBottomSheet(context);
        },
        child: Icon(Icons.add,color: Colors.white,),
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }

  void _showDeleteAlertDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Patient?"),
          content: Text("Do you want to delete the patient from the list?"),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  admittedNeedyPatients.removeAt(index);
                  filteredPatients = List.from(admittedNeedyPatients); // Update filtered list
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

  void _showEditBottomSheet(BuildContext context, Map<String, dynamic> patient, int index) {
    TextEditingController nameController = TextEditingController(text: patient['name']);
    TextEditingController ageController = TextEditingController(text: patient['age'].toString());
    TextEditingController wardNumberController = TextEditingController(text: patient['wardNumber']);
    TextEditingController bedNumberController = TextEditingController(text: patient['bedNumber']);
    TextEditingController diseaseController = TextEditingController(text: patient['disease']);
    TextEditingController imageUrlController = TextEditingController(text: patient['imageUrl']);

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
                    controller: ageController,
                    decoration: InputDecoration(labelText: 'Age'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: wardNumberController,
                    decoration: InputDecoration(labelText: 'Ward Number'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: bedNumberController,
                    decoration: InputDecoration(labelText: 'Bed Number'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: diseaseController,
                    decoration: InputDecoration(labelText: 'Disease'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: imageUrlController,
                    decoration: InputDecoration(labelText: 'Image URL'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        admittedNeedyPatients[index]['name'] = nameController.text;
                        admittedNeedyPatients[index]['age'] = int.parse(ageController.text);
                        admittedNeedyPatients[index]['wardNumber'] = wardNumberController.text;
                        admittedNeedyPatients[index]['bedNumber'] = bedNumberController.text;
                        admittedNeedyPatients[index]['disease'] = diseaseController.text;
                        admittedNeedyPatients[index]['imageUrl'] = imageUrlController.text;
                        filteredPatients[index]['name'] = nameController.text;
                        filteredPatients[index]['age'] = int.parse(ageController.text);
                        filteredPatients[index]['wardNumber'] = wardNumberController.text;
                        filteredPatients[index]['bedNumber'] = bedNumberController.text;
                        filteredPatients[index]['disease'] = diseaseController.text;
                        filteredPatients[index]['imageUrl'] = imageUrlController.text;
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
    TextEditingController ageController = TextEditingController();
    TextEditingController wardNumberController = TextEditingController();
    TextEditingController bedNumberController = TextEditingController();
    TextEditingController diseaseController = TextEditingController();
    TextEditingController imageUrlController = TextEditingController();

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
                    controller: ageController,
                    decoration: InputDecoration(labelText: 'Age'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: wardNumberController,
                    decoration: InputDecoration(labelText: 'Ward Number'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: bedNumberController,
                    decoration: InputDecoration(labelText: 'Bed Number'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: diseaseController,
                    decoration: InputDecoration(labelText: 'Disease'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: imageUrlController,
                    decoration: InputDecoration(labelText: 'Image URL'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        admittedNeedyPatients.add({
                          'name': nameController.text,
                          'age': int.parse(ageController.text),
                          'wardNumber': wardNumberController.text,
                          'bedNumber': bedNumberController.text,
                          'disease': diseaseController.text,
                          'imageUrl': imageUrlController.text,
                        });
                        filteredPatients = admittedNeedyPatients;
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
