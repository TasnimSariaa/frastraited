import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/screens/Payments_screen.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/Precentation/ui/widgets/empty_container_view.dart';
import 'package:frastraited/screen/service/database_service.dart';
import 'package:frastraited/screen/service/models/donation_model.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';
import 'package:frastraited/screen/widgets/custom_image_view.dart';

class Donation extends StatefulWidget {
  const Donation({Key? key}) : super(key: key);

  @override
  State<Donation> createState() => _DonationState();
}

class _DonationState extends State<Donation> {
  List<DonationModel> donationList = [];
  List<DonationModel> tempDonationList = [];

  bool isLoading = true;

  // Controller for search text field
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getDonationList();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _getDonationList() async {
    final result = await DatabaseService.instance.getDonationList();
    donationList.clear();
    donationList.addAll(result);
    tempDonationList = donationList;
    isLoading = false;
    setState(() {});
  }

  void _onSearchChanged() {
    String query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      tempDonationList = donationList;
    } else {
      tempDonationList = donationList.where((value) {
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
        child: SafeArea(
          child: SingleChildScrollView(
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
                const SizedBox(height: 40),
                TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Admitted Needy Patients',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 30),
                _view,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get _view {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (donationList.isEmpty) {
      return const Center(child: EmptyContainerView());
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: tempDonationList.length,
        itemBuilder: (BuildContext context, int index) {
          final patient = tempDonationList[index];
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
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(patient.name),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Age: ${patient.age}'),
                          Text('Ward Number: ${patient.wardNumber}'),
                          Text('Payment Number: ${patient.bkashNumber}'),
                          Text('Bed Number: ${patient.bedNumber}'),
                          Text('Disease: ${patient.disease}'),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            TextEditingController donationAmountController = TextEditingController();
                            final GlobalKey<FormState> formKey = GlobalKey<FormState>();
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Donation Amount'),
                                content: Form(
                                  key: formKey,
                                  child: TextFormField(
                                    controller: donationAmountController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(hintText: 'Enter the amount'),
                                    validator: (val) {
                                      if (val == null || val.isEmpty) {
                                        return "Field is required";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      final isValid = formKey.currentState?.validate() ?? false;
                                      if (!isValid) return;

                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PaymentsScreen(
                                            category: 'Donation',
                                            type: patient.name,
                                            payable: donationAmountController.text,
                                            donationUser: patient.toJson(),
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text('Process'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const Text("Donate"),
                        ),
                        if (patient.imageUrl.isNotEmpty)
                          TextButton(
                            child: const Text("See Photos"),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return CustomImageView(
                                    path: patient.imageUrl,
                                  );
                                },
                              );
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
      );
    }
  }
}
