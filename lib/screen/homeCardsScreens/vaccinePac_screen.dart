import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/Precentation/ui/utility/search_field.dart'; // Import the SearchField widget
import 'package:frastraited/Precentation/ui/widgets/empty_container_view.dart';
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
  List<VaccineModel> tempVaccineList = [];

  bool isLoading = true;

  // Controller for search text field
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getVaccineList();
    searchController.addListener(_onSearchChanged);
  }

  void _getVaccineList() async {
    final result = await DatabaseService.instance.getVaccineInformation();
    vaccineList.clear();
    vaccineList.addAll(result);
    tempVaccineList = vaccineList;
    isLoading = false;
    setState(() {});
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Function to handle changes in the search text field
  void _onSearchChanged() {
    String query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      tempVaccineList = vaccineList;
    } else {
      tempVaccineList = vaccineList.where((value) {
        String name = value.name.toLowerCase();
        return name.contains(query);
      }).toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyBackground(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : vaccineList.isEmpty
                ? const Center(child: EmptyContainerView())
                : SingleChildScrollView(
                    padding: const EdgeInsetsDirectional.only(start: 20, end: 20, bottom: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 24),
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
                        SearchField(
                          controller: searchController,
                          onTextChanged: (value) {},
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Available Vaccines',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ListView.separated(
                          shrinkWrap: true,
                          separatorBuilder: (_, __) => const SizedBox(height: 20),
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: tempVaccineList.length,
                          itemBuilder: (BuildContext context, int index) {
                            final vaccine = tempVaccineList[index];
                            return Container(
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
                                children: [
                                  Container(
                                    width: 120,
                                    height: 120,
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    margin: const EdgeInsetsDirectional.only(end: 10),
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
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          vaccine.name,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          'Available at: ${vaccine.place}',
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          'Price: ${vaccine.price}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
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
                            );
                          },
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
