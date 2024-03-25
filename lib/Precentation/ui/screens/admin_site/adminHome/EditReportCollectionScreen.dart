import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/screen/service/database_service.dart';
import 'package:frastraited/screen/service/models/collect_reports_model.dart';
import 'package:frastraited/screen/service/models/users.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';
import 'package:frastraited/screen/widgets/custom_image_view.dart';

class EditReportCollection extends StatefulWidget {
  const EditReportCollection({super.key});

  @override
  State<EditReportCollection> createState() => _EditReportCollectionState();
}

class _EditReportCollectionState extends State<EditReportCollection> {
  List<CollectReportsModel> collectReportList = [];
  List<UsersModel> userList = [];

  UsersModel selectedUser = UsersModel.empty();

  bool isLoading = true;

  String _downloadUrl = '';

  @override
  void initState() {
    super.initState();
    _getCollectReportList();
    _getUserList();
  }

  void _getUserList() async {
    userList = await DatabaseService.instance.getUserList();
  }

  void _getCollectReportList() async {
    collectReportList.clear();
    final result = await DatabaseService.instance.getCollectReportsList();
    collectReportList.addAll(result);
    isLoading = false;
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
                  const SizedBox(height: 10),
                  Text(
                    'Upload Reports',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _showUploadReportBottomSheet(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                    ),
                    child: const Text(
                      '   Upload Report  ',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ..._listView,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> get _listView {
    if (isLoading) {
      return [const Center(child: CircularProgressIndicator())];
    }
    if (collectReportList.isEmpty) {
      return [const Center(child: Text("List is Empty"))];
    }
    return List.generate(collectReportList.length, (index) {
      final report = collectReportList[index];
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsetsDirectional.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Medical Id: ${report.medicalId}"),
            const SizedBox(height: 10),
            Wrap(
              runSpacing: 10,
              spacing: 10,
              children: List.generate(
                report.reportList.length,
                (innerIndex) {
                  final item = report.reportList[innerIndex];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.picture_as_pdf, size: 40),
                      const SizedBox(height: 10),
                      Text(item.reportName),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  void _showUploadReportBottomSheet(BuildContext context) {
    TextEditingController medicalIdController = TextEditingController();
    TextEditingController testNameController = TextEditingController();

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    selectedUser = UsersModel.empty();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
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
                  "Report Information",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: medicalIdController,
                  decoration: const InputDecoration(labelText: 'Medical ID'),
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
                                      medicalIdController.text = "${selectedUser.firstName} (${selectedUser.medicalId})";
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
                const SizedBox(height: 16),
                TextFormField(
                  controller: testNameController,
                  decoration: const InputDecoration(labelText: 'Name of the Test'),
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
                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowCompression: false,
                      allowMultiple: false,
                      allowedExtensions: ['pdf', 'doc'],
                    );

                    if (result != null) {
                      PlatformFile file = result.files.first;

                      _uploadImage(File(file.path!));
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Icon(
                          Icons.upload_rounded,
                          color: Colors.white,
                        ),
                        Text(
                          ' Upload Report File ',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    final isValid = formKey.currentState?.validate() ?? false;
                    if (!isValid) return;

                    final medicalId = medicalIdController.text;
                    final testName = testNameController.text;
                    CollectReportsModel model = CollectReportsModel(
                      id: "",
                      medicalId: medicalId,
                      payable: "100",
                      isReady: true,
                      reportList: [
                        ReportInfoModel(reportName: testName, reportUrl: _downloadUrl),
                      ],
                    );
                    await DatabaseService.instance.addCollectReports(model);
                    _getCollectReportList();
                    Navigator.pop(context);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Add',
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

  void _showDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(child: CircularProgressIndicator()),
            ],
          ),
        );
      },
    );
  }

  void _uploadImage(File file) async {
    _showDialog();
    final user = FirebaseAuth.instance.currentUser;
    final storage = FirebaseStorage.instance;
    final Reference storageRef = storage.ref().child('files/${user?.uid}/${DateTime.now().toString()}');
    final UploadTask uploadTask = storageRef.putFile(file);
    await uploadTask.whenComplete(() async {
      _downloadUrl = await storageRef.getDownloadURL();
      Navigator.pop(context);
    });
    setState(() {});
  }
}
