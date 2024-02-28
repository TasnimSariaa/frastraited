import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/Precentation/ui/utility/search_field.dart'; // Import the SearchField widget
import 'package:frastraited/Precentation/ui/widgets/empty_container_view.dart';
import 'package:frastraited/screen/service/database_service.dart';
import 'package:frastraited/screen/service/models/pending_test_model.dart';
import 'package:frastraited/screen/service/models/user_test_model.dart';
import 'package:frastraited/screen/service/models/users.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';
import 'package:frastraited/screen/widgets/custom_image_view.dart';

class EditPendingTest extends StatefulWidget {
  const EditPendingTest({super.key});

  @override
  State<EditPendingTest> createState() => _EditPendingTestState();
}

class _EditPendingTestState extends State<EditPendingTest> {
  List<PendingTestModel> pendingTestList = [];
  List<PendingTestModel> tempPendingTestList = [];

  bool isLoading = true;

  // Controller for search text field
  TextEditingController searchController = TextEditingController();

  List<UsersModel> userList = [];
  UsersModel selectedUser = UsersModel.empty();

  @override
  void initState() {
    super.initState();
    _getPendingTestList();
    _getUserList();
    searchController.addListener(_onSearchChanged);
  }

  void _getUserList() async {
    userList = await DatabaseService.instance.getUserList();
  }

  void _getPendingTestList() async {
    final result = await DatabaseService.instance.getPendingTest();
    pendingTestList.clear();
    pendingTestList.addAll(result);
    tempPendingTestList = pendingTestList;
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
      tempPendingTestList = pendingTestList;
    } else {
      tempPendingTestList = pendingTestList.where((patient) {
        String patientName = patient.name.toLowerCase();
        return patientName.contains(query);
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
                  const SizedBox(height: 20),
                  const Text(
                    'All Tests',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SearchField(
                    // Use the SearchField widget
                    controller: searchController,
                    onTextChanged: (value) {},
                  ),
                  const SizedBox(height: 40),
                  // Displaying list of pending tests
                  _view,
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTestBottomSheet(context);
        },
        backgroundColor: AppColors.primaryColor, // Set the background color
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget get _view {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (pendingTestList.isEmpty) {
      return const Center(child: EmptyContainerView());
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: pendingTestList.length,
        itemBuilder: (context, index) {
          final test = pendingTestList[index];
          return Container(
            height: 87,
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      test.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Amount: ${test.amount}',
                      style: const TextStyle(color: Colors.blueGrey),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    _showAddPatientBottomSheet(context, test);
                  },
                  child: const Text(
                    '  Add for Patient ',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  // Function to show the bottom sheet for adding patient
  void _showAddPatientBottomSheet(BuildContext context, PendingTestModel test) {
    TextEditingController editingController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enter Patient Medical ID:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: editingController,
                  decoration: const InputDecoration(
                    hintText: 'Enter Medical ID',
                  ),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return SingleChildScrollView(
                          padding: const EdgeInsetsDirectional.only(start: 20, end: 20, bottom: 40, top: 30),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(userList.length, (index) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      selectedUser = userList[index];
                                      editingController.text = "${selectedUser.firstName} (${selectedUser.medicalId})";
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                    child: Card(
                                      borderOnForeground: true,
                                      color: Colors.white,
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: selectedUser == userList[index] ? const BorderSide(color: AppColors.primaryColor, width: 2) : BorderSide.none,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            CustomImageView(
                                              height: 60,
                                              width: 60,
                                              path: userList[index].profileUrl,
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text("${userList[index].firstName} ${userList[index].lastName}"),
                                                  const SizedBox(height: 4),
                                                  Text(userList[index].medicalId),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              );
                            }),
                          ),
                        );
                      },
                    );
                  },
                  readOnly: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final isValid = formKey.currentState?.validate() ?? false;
                    if (!isValid) return;

                    final userPendingTestModel = UserTestModel(
                      id: "",
                      medicalId: selectedUser.medicalId,
                      usersModel: selectedUser,
                      pendingTestModel: test,
                    );
                    await DatabaseService.instance.setPendingTest(userPendingTestModel);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Add',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddTestBottomSheet(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController feeController = TextEditingController();

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Medical Test Information",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Field is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: feeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Visiting Fee'),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Field is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    final isValid = formKey.currentState?.validate() ?? false;
                    if (!isValid) return;

                    final name = nameController.text;
                    final fee = feeController.text;
                    PendingTestModel model = PendingTestModel(
                      id: "",
                      name: name,
                      amount: fee,
                    );
                    await DatabaseService.instance.addNewTest(model);
                    _getPendingTestList();
                    Navigator.pop(context);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Add Doctor',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
