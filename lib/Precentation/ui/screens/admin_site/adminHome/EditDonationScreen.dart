import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/screen/service/database_service.dart';
import 'package:frastraited/screen/service/models/donation_model.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';

class EditDonation extends StatefulWidget {
  const EditDonation({super.key});

  @override
  State<EditDonation> createState() => _EditDonationState();
}

class _EditDonationState extends State<EditDonation> {
  TextEditingController searchController = TextEditingController();

  List<DonationModel> donationList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
    _getDonationList();
  }

  void _getDonationList() async {
    donationList.clear();
    final result = await DatabaseService.instance.getDonationList();
    donationList.addAll(result);
    isLoading = false;
    setState(() {});
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    String query = searchController.text.toLowerCase();
    // setState(() {
    //   filteredPatients = admittedNeedyPatients.where((patient) {
    //     String patientName = patient['name'].toLowerCase();
    //     return patientName.contains(query);
    //   }).toList();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyBackground(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : donationList.isEmpty
                ? const Center(child: Text("List is Empty"))
                : SafeArea(
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
                            const SizedBox(height: 10),
                            Text(
                              'Admitted Needy Patients',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: searchController,
                              decoration: const InputDecoration(
                                labelText: 'Search',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 30),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: donationList.length,
                              itemBuilder: (BuildContext context, int index) {
                                final patient = donationList[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 4,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        title: Text(patient.name),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Age: ${patient.age}'),
                                            Text('Ward Number: ${patient.wardNumber}'),
                                            Text('Bed Number: ${patient.bedNumber}'),
                                            Text('Disease: ${patient.disease}'),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              // Handle the action for uploading patient's picture
                                            },
                                            icon: const Icon(Icons.file_upload),
                                            label: const Text('Upload Picture   '),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.primaryColor,
                                              onPrimary: Colors.white,
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.edit),
                                                onPressed: () {
                                                  _showEditBottomSheet(context, patient);
                                                },
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.delete),
                                                onPressed: () {
                                                  _showDeleteAlertDialog(context, patient);
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
        backgroundColor: AppColors.primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showDeleteAlertDialog(BuildContext context, DonationModel model) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Patient?"),
          content: const Text("Do you want to delete the patient from the list?"),
          actions: [
            TextButton(
              onPressed: () async {
                donationList.remove(model);
                await DatabaseService.instance.deleteDonations(model);
                _getDonationList();
                setState(() {});
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(AppColors.primaryColor),
              ),
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void _showEditBottomSheet(BuildContext context, DonationModel patient) {
    TextEditingController nameController = TextEditingController(text: patient.name);
    TextEditingController ageController = TextEditingController(text: patient.age);
    TextEditingController wardNumberController = TextEditingController(text: patient.wardNumber);
    TextEditingController bedNumberController = TextEditingController(text: patient.bedNumber);
    TextEditingController diseaseController = TextEditingController(text: patient.disease);

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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: ageController,
                    decoration: const InputDecoration(labelText: 'Age'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: wardNumberController,
                    decoration: const InputDecoration(labelText: 'Ward Number'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: bedNumberController,
                    decoration: const InputDecoration(labelText: 'Bed Number'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: diseaseController,
                    decoration: const InputDecoration(labelText: 'Disease'),
                  ),
                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: () async {
                      final name = nameController.text;
                      final age = ageController.text;
                      final wardNumber = wardNumberController.text;
                      final bedNumber = bedNumberController.text;
                      final disease = diseaseController.text;
                      await DatabaseService.instance.updateDonations(
                        patient.copyWith(
                          name: name,
                          age: age,
                          wardNumber: wardNumber,
                          bedNumber: bedNumber,
                          disease: disease,
                        ),
                      );
                      _getDonationList();
                      Navigator.pop(context);
                    },
                    child: const Text('Update', style: TextStyle(color: Colors.white)),
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: ageController,
                    decoration: const InputDecoration(labelText: 'Age'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: wardNumberController,
                    decoration: const InputDecoration(labelText: 'Ward Number'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: bedNumberController,
                    decoration: const InputDecoration(labelText: 'Bed Number'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: diseaseController,
                    decoration: const InputDecoration(labelText: 'Disease'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final name = nameController.text;
                      final age = ageController.text;
                      final wardNumber = wardNumberController.text;
                      final bedNumber = bedNumberController.text;
                      final disease = diseaseController.text;
                      DonationModel donation = DonationModel(
                        id: "",
                        name: name,
                        age: age,
                        wardNumber: wardNumber,
                        bedNumber: bedNumber,
                        disease: disease, imageUrl: '',
                      );
                      await DatabaseService.instance.addDonations(donation);
                      _getDonationList();
                      Navigator.pop(context);
                    },
                    child: const Text('Add', style: TextStyle(color: Colors.white)),
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
