import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/screen/onboarding/loginScreen.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';

class EditReportCollection extends StatefulWidget {
  const EditReportCollection({Key? key}) : super(key: key);

  @override
  State<EditReportCollection> createState() => _EditReportCollectionState();
}

class _EditReportCollectionState extends State<EditReportCollection> {
  TextEditingController medicalIdController = TextEditingController();
  TextEditingController testNameController = TextEditingController();

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
                    child: const Text(
                      '   Upload Report  ',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showUploadReportBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
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
                  TextField(
                    controller: medicalIdController,
                    decoration: const InputDecoration(labelText: 'Medical ID'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: testNameController,
                    decoration: const InputDecoration(labelText: 'Name of the Test'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Handle the action for uploading report file
                      // You can access the entered medical ID and test name via medicalIdController.text and testNameController.text respectively
                      Navigator.pop(context); // Close the bottom sheet
                    },
                     child:const Row(
                       children: [
                         Icon(Icons.upload_rounded,color: Colors.white,),
                         Text(' Upload Report File',
                         style: TextStyle(color: Colors.white),),

                       ],
                     ),
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
