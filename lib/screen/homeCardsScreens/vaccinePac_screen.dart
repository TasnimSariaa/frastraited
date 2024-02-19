import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/Precentation/ui/utility/search_field.dart'; // Import the SearchField widget
import 'package:frastraited/screen/service/database_service.dart';
import 'package:frastraited/screen/service/models/vaccines.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';

class VaccineScreen extends StatefulWidget {
  const VaccineScreen({super.key});

  @override
  State<VaccineScreen> createState() => _VaccineScreenState();
}

class _VaccineScreenState extends State<VaccineScreen> {
  List<VaccineModel> vaccineList = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getVaccineList();
    searchController.addListener(_onSearchChanged);
  }

  void _getVaccineList() async {
    vaccineList.clear();
    final result = await DatabaseService.instance.getVaccineInformation();
    vaccineList.addAll(result);
    isLoading = false;
    setState(() {});
  }

  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Function to handle changes in the search text field
  void _onSearchChanged() {
    String query = searchController.text.toLowerCase();
    // setState(() {
    //   filteredVaccines = availableVaccines.where((vaccine) {
    //     String vaccineName = vaccine['name'].toLowerCase();
    //     return vaccineName.contains(query);
    //   }).toList();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyBackground(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : vaccineList.isEmpty
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
                            const Text(
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
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: vaccineList.length,
                              itemBuilder: (BuildContext context, int index) {
                                final vaccine = vaccineList[index];
                                return Column(
                                  children: [
                                    Container(
                                      height: 140,
                                      margin: const EdgeInsets.symmetric(vertical: 10),
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
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 120,
                                            height: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(12),
                                                bottomLeft: Radius.circular(12),
                                              ),
                                              image: DecorationImage(
                                                image: NetworkImage(vaccine.vaccineImageUrl),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  vaccine.name,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.primaryColor,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  'Available at: ${vaccine.place}',
                                                  style: const TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  'Price: ${vaccine.price}',
                                                  style: const TextStyle(
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
