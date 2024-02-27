import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/Precentation/ui/utility/search_field.dart'; // Import the SearchField widget
import 'package:frastraited/Precentation/ui/widgets/empty_container_view.dart';
import 'package:frastraited/screen/service/database_service.dart';
import 'package:frastraited/screen/service/models/operationPackages.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';

class OperationScreen extends StatefulWidget {
  const OperationScreen({super.key});

  @override
  State<OperationScreen> createState() => _OperationScreenState();
}

class _OperationScreenState extends State<OperationScreen> {
  List<OperationModel> operationList = [];
  List<OperationModel> tempOperationList = [];
  bool isLoading = true;

  // Controller for search text field
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getOperationList();
    searchController.addListener(_onSearchChanged);
  }

  void _getOperationList() async {
    final result = await DatabaseService.instance.getOperationInformation();
    operationList.clear();
    operationList.addAll(result);
    tempOperationList = operationList;
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
      tempOperationList = operationList;
    } else {
      tempOperationList = operationList.where((value) {
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
            : operationList.isEmpty
                ? const Center(child: EmptyContainerView())
                : SafeArea(
                    child: SingleChildScrollView(
                      padding: const EdgeInsetsDirectional.only(start: 20, end: 20, bottom: 40),
                      child: Column(
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
                          const SizedBox(height: 10),
                          const Text(
                            'Available Operations',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 40),
                          ListView.separated(
                            shrinkWrap: true,
                            separatorBuilder: (_, __) => const SizedBox(height: 20),
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: tempOperationList.length,
                            itemBuilder: (BuildContext context, int index) {
                              final package = tempOperationList[index];
                              return Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: const Offset(0, 2), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 120,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          bottomLeft: Radius.circular(8),
                                        ),
                                        image: DecorationImage(
                                          image: NetworkImage(package.operationImageUrl),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            package.name,
                                            maxLines: 2,
                                            style: const TextStyle(fontSize: 18, color: AppColors.primaryColor),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            package.description,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(color: Colors.grey),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Amount: ${package.amount}',
                                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
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
      ),
    );
  }
}
